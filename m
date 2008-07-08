Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.224]:21464 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbYGHOLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 10:11:21 -0400
Received: by qb-out-0506.google.com with SMTP id d8so5682248qbc.37
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 07:11:20 -0700 (PDT)
Message-ID: <3ace41890807080711n4bbb9f99y5ddcf8f672f760ee@mail.gmail.com> (sfid-20080708_161124_963645_7B14921C)
Date: Tue, 8 Jul 2008 15:11:19 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 0/6] rtl8187: Adding Realtek rtl8187B support
Cc: herton@mandriva.com.br, proski@gnu.org,
	"John Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48736E18.5060708@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <3ace41890807080412w3f24a8c1wa2665d8d6de785c9@mail.gmail.com>
	 <48736E18.5060708@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 8, 2008 at 2:39 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Hin-Tak,
>
> Good job getting these posted. For the first time in a long time, my unit
> was able to connect and authenticate. It certainly looks as if you solved
> the ep12 problem. I'm using the device to write this E-mail.

Very good! I am wondering about whether Pavel's negative experience came
from the accidental brokenness after tidy up. The clean version is so
obviously cleaner,
except it moved the management frame decision after skb_pull() which
munched skb.
That's so *unobvious* - I don't expect any structs with ->data, etc to
be mutate.

I only spotted the difference when I load the two modules one
after the other and I wasn't getting the same connectivity -
and looked at the diffs from usbmon in debugfs. (obviously
if I am sending in the patches I need to "eat-my-own-dog-food").

> Unfortunately, your mailer still wrapped some lines in the patches. It
> wasn't difficult to repair them, but it still is a bother. For the next
> round, we can work out a procedure that uses the mail utility to send the
> patches. I've used this method since Linville was unable to process my
> patches that were sent from Thunderbird.

Damn... Yes, I just looked at my gmail Sent folder and saw that.
What do people do to send in-line patches? I guess I have to learn to use
git-send-email properly. This is too hard :-).

> The patch to revise the detection of B units with an 8187 ID is ready. I can
> send it at any time.

Only you have the right hardware to test, so go ahead and post if you
are happy with the change.

Hin-Tak
