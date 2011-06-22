Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44956 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1FVB7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 21:59:50 -0400
Received: by vxb39 with SMTP id 39so280913vxb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 18:59:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FF88DF06@SC-VEXCH1.marvell.com>
References: <1308352468-8926-1-git-send-email-bzhao@marvell.com>
 <BANLkTi=3cQkhEOkSb08A=8VLrqzkwXJEhw@mail.gmail.com> <477F20668A386D41ADCC57781B1F704307FF88DF06@SC-VEXCH1.marvell.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 22 Jun 2011 11:59:29 +1000
Message-ID: <BANLkTimkmJGyS3FSE4isARPJtc-v3tkNuw@mail.gmail.com> (sfid-20110622_035954_021822_C3861A8A)
Subject: Re: [PATCH] mwifiex: remove casts of void pointers
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On Wed, Jun 22, 2011 at 11:09, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Julian,
>
>> Also, there are a number of functions touched by this patch that
>> return a value through the former *data_buf parameter. Is it possible
>> to refactor them to return the value directly? This would make the
>> function flow a lot cleaner and easier to follow.
>
> We have separate parser routines to handle command responses of the commands. In case of GET command we parse the information from response buffer and fill data_buff accordingly. In the patch we submitted, some of the data_buf have been changed to corresponding structure specific to that command.
>
> Yes, we do have some parser functions that only fill an u16/u32 value in data_buf. But in order to have consistency in the code, we used the data_buf pointers (or specific command struct pointers) for all parser functions. Of course we can change the code to return the value directly for this type of functions, if the consistency is less concerned here. Please let me know your preference on this.

I have no preference, and am not aware of any particular general
preferences for how such things are handled.

If it makes things easier for you, then keep it as it is, it just
seemed like a useful cleanup you might want to consider working on in
the future.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
