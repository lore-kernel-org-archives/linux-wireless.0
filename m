Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49277 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757714Ab1FVCQR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 22:16:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Joe Perches <joe@perches.com>
Date: Tue, 21 Jun 2011 19:13:09 -0700
Subject: RE: [PATCH] mwifiex: remove casts of void pointers
Message-ID: <477F20668A386D41ADCC57781B1F704307FF88DF38@SC-VEXCH1.marvell.com> (sfid-20110622_041631_329752_464C6C06)
References: <1308352468-8926-1-git-send-email-bzhao@marvell.com>
 <BANLkTi=3cQkhEOkSb08A=8VLrqzkwXJEhw@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F704307FF88DF06@SC-VEXCH1.marvell.com>
 <BANLkTimkmJGyS3FSE4isARPJtc-v3tkNuw@mail.gmail.com>
In-Reply-To: <BANLkTimkmJGyS3FSE4isARPJtc-v3tkNuw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

> >> Also, there are a number of functions touched by this patch that
> >> return a value through the former *data_buf parameter. Is it possible
> >> to refactor them to return the value directly? This would make the
> >> function flow a lot cleaner and easier to follow.
> >
> > We have separate parser routines to handle command responses of the commands. In case of GET
> command we parse the information from response buffer and fill data_buff accordingly. In the patch we
> submitted, some of the data_buf have been changed to corresponding structure specific to that command.
> >
> > Yes, we do have some parser functions that only fill an u16/u32 value in data_buf. But in order to
> have consistency in the code, we used the data_buf pointers (or specific command struct pointers) for
> all parser functions. Of course we can change the code to return the value directly for this type of
> functions, if the consistency is less concerned here. Please let me know your preference on this.
> 
> I have no preference, and am not aware of any particular general
> preferences for how such things are handled.
> 
> If it makes things easier for you, then keep it as it is, it just
> seemed like a useful cleanup you might want to consider working on in
> the future.

Thanks for your comments. I will keep it as-is for now.

Regards,
Bing 

