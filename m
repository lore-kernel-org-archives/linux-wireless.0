Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53415 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab1HXXMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 19:12:13 -0400
Received: by ywf7 with SMTP id 7so1253179ywf.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 16:12:13 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 24 Aug 2011 16:11:53 -0700
Message-ID: <CAB=NE6UcT8gzVWW+stLEy2SKBCdt-wVnv6aWOZBKTurXk1W0YA@mail.gmail.com> (sfid-20110825_011225_586181_E35D9BBB)
Subject: Regulatory simulator - regulatory revamp work
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Arun Venkataraman <arunvenk@qca.qualcomm.com>,
	Prem Kumar <prem@qca.qualcomm.com>,
	Matt Smith <smithm@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: this is a public e-mail

As I mentioned at the Linux wireless summit we want to revamp the
regulatory code on Linux to take into consideration some new features
and to make the code a bit easier to follow and manage, and most
importantly do unit tests outside of the kernel through a userspace
testbed which can prove validity of the data and all possible states
we can run into. This can also help other OSes which may want to
cherry pick the code into their own solutions and hopefully create
more traction on embracing and working together towards a more unified
regulatory database.

I've dumped some initial code here:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/regsim.git

The first goal is to start embracing the formal definition of a
regulatory domain and rules that a frequency should match to by
Johannes a while ago:

     0) for all 1 <= k < n : MAX_k <= MIN_{k+1}

     1) each rule in the regdomain covers the frequency range (MIN_1, MAX_1]

     2) given C = union (over all k = 1 .. n) of (MIN_k, MAX_k] it must be
       true that (CENTER - BW/2, CENTER + BW/2) is a subset of C

     3) it must be true for all 1 <= k <= n:
           if CENTER in (MIN_k, MAX_k] : BW <= BW_k

     4) This is easier to formulate algorithmically:
       USE_FLAGS = 0
       for k = 1 .. n
           if (CENTER - BW/2, CENTER + BW/2) intersects (MIN_k, MAX_k]:
               USE_FLAGS |= FLAGS_k

This intends on addressing regulatory domains which may have
overlapping rules or TPC rules for different bandwidths -- all of
which do not exist today as far as I'm concerned but certainly do
limit our architecture as it is today. I intend on testing this by
creating a test regulator domain under main.c which has some
overlapping frequency rules and ensuring that the target rule picked
matches the above definition.

Next we should review 802.11mb stuff and the "operating class"
extensions, and see if we can throw some of that to the framework to
intersect the existing rules. This will take care of the operating
class requirements for 802.11ad. For this I will need some help on the
language used on 11mb operating classes. For 802.11ac I didn't get any
new concerns or architecture change requirements. For TV space.. its a
bit different and we will have the external regulatory database we
will need to talk to but -- not sure how that fits into this stuff. If
someone is working on that I'd appreciate review or feedback.

After that will be adding some form of state machine for each possible
regulatory state we can get into and then adding all possible events
and changes to the state machine. Then we start simulating devices and
them moving around all possible states, exposing allowed channels,
output power, etc, and comparing this against expected results.

If you'd like to help feel free to coordinate on #linux-wireless on
irc.freenode.net or on this list. Patches always welcomed.

  Luis
