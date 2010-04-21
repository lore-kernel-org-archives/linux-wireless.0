Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50278 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab0DUH3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 03:29:47 -0400
Received: by pwj9 with SMTP id 9so4898625pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 00:29:46 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 21 Apr 2010 00:29:26 -0700
Message-ID: <w2v43e72e891004210029g15eaf50fwbca39a73b7c46268@mail.gmail.com>
Subject: ath9k initvals-tool - integrity checks | reformat | synchronize
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "doug.dahlby" <Doug.Dahlby@atheros.com>,
	Atheros Internal ath9k development team
	<ath9k-devel@atheros.com>, Cliff Holden <Cliff.Holden@atheros.com>,
	Zhifeng Cai <zhifeng.cai@atheros.com>,
	Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the v2 patch cover letter for AR9003 I noted how I had started some
simple initval userspcae tool to check the integrity of the initvals.
Since we also had some discussions about the possible format changes
for it I've gone ahead and extended the same tool to also reformat our
initvals to any format we like and at the same time allowing us to
verify the integrity is kept. This same tool can now be used by us at
Atheros to check for changes quickly between our Atheros HAL and the
ath9k_hw module. I've written some docs how to do all this here:

http://wireless.kernel.org/en/users/Drivers/ath9k_hw/initvals-tool

We have a few initval patches not yet submitted for AR9003, once we
shoot those out, and they get merged, we can then start talking about
the preferred format we want for these initvals and rewrite
ath9k_hw_print_initval() to our liking, and then keep using that
moving forward. We will still need to eventually merge these same
files into the Atheros HAL so we just have the same initvals
style/format everywhere but this should help somewhat with this. The
Atheros HAL uses some other tool to generate the initvals, that will
just need to be modified to accommodate the desired upon style on
Linux and we can finally move on with other things to synchronize.

Let me know if you have any questions.

  Luis
