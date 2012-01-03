Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46306 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab2ACAoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 19:44:24 -0500
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id C6E2C214A1
	for <linux-wireless@vger.kernel.org>; Mon,  2 Jan 2012 19:44:23 -0500 (EST)
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <201201022331.27562.marek.vasut@gmail.com> <4F023D02.1030403@fastmail.fm> <201201030131.15397.marek.vasut@gmail.com>
In-Reply-To: <201201030131.15397.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: loading firmware while usermodehelper disabled.
From: Jack Stone <jwjstone@fastmail.fm>
Date: Tue, 03 Jan 2012 00:44:07 +0000
To: Marek Vasut <marek.vasut@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>,
	Matthew Garrett <mjg@redhat.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Message-ID: <c163595a-163e-4e68-ba0f-de5ca58e8de9@email.android.com> (sfid-20120103_014445_986286_3B0E31EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Marek Vasut <marek.vasut@gmail.com> wrote:

>> On 02/01/12 22:31, Marek Vasut wrote:
>> >> I don't think there is anyway to avoid the memory requirement if
>we want
>> >> to be able to resume transparently to user-space (or even resume
>at all
>> >> in some setups).
>> > 
>> > Well ... injecting firmware into kernel with some userland helper
>just
>> > before suspend is no-go?
>> 
>> Its a perfectly good idea but you still need the full memory
>requirement
>> during the suspend.
>
>Hm ... and we can't have memory type that "can be swapped-out, but must
>be 
>loaded back before suspend" in kernel, right?

Nope. Kernel swapping is a big headache and Linux doesn't do it. The only thing we can do is drop any clean cache pages, but that has performance implications.

Thanks,

Jack

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
