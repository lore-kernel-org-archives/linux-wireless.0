Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49612 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYJFRyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 13:54:37 -0400
Date: Mon, 6 Oct 2008 13:53:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: [PATCH] mac80211: avoid "Wireless Event too big" message for
	assoc response
Message-ID: <20081006175357.GB3448@tuxdriver.com> (sfid-20081006_195441_007814_4C59EA88)
References: <1222890302-32486-1-git-send-email-linville@linville-t61.local> <48E53C1F.4040909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48E53C1F.4040909@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 02, 2008 at 10:24:47PM +0100, Dave wrote:
> John W. Linville wrote:
>> An attempt was made by Jouni Malinen to correct this issue by
>> converting to use IWEVASSOCREQIE and IWEVASSOCRESPIE messages instead
>> ("mac80211: Use IWEVASSOCREQIE instead of IWEVCUSTOM").  Unfortunately,
>> that caused a problem due to 32-/64-bit interactions on some systems and
>> was reverted after the 'userland ABI' rule was invoked.
>
> I was unaware of this, and used IWEVASSOCREQIE and IWEVASSOCRESPIE in the
> orinoco wpa updates since the events were available in linux/wireless.h.
>
> Should I post a patch to use IWEVCUSTOM instead?

Honestly, I don't know.  I think we would prefer not to use the
IWEVCUSTOM method, but my memory is not 100% clear on what triggered
the 32-/64-bit problem.  Perhaps Jouni can comment?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
