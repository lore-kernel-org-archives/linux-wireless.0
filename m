Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33834 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbcFPP4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:56:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>
Cc: Guenter Roeck <linux@roeck-us.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [v3,1/2] b43: Remove unused phy_a code
References: <1465052053-26740-1-git-send-email-linux@roeck-us.net>
	<20160616152337.63AB261421@smtp.codeaurora.org>
	<20160616174813.595440bb@wiggum>
Date: Thu, 16 Jun 2016 18:56:14 +0300
In-Reply-To: <20160616174813.595440bb@wiggum> ("Michael =?utf-8?Q?B=C3=BCs?=
 =?utf-8?Q?ch=22's?= message of
	"Thu, 16 Jun 2016 17:48:13 +0200")
Message-ID: <87y465unz5.fsf@kamboji.qca.qualcomm.com> (sfid-20160616_175647_461150_7C86A917)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Büsch <m@bues.ch> writes:

> On Thu, 16 Jun 2016 15:23:37 +0000 (UTC)
> Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> Guenter Roeck <linux@roeck-us.net> wrote:
>> > gcc-6 reports the following error with -Werror=unused-const-variable.
>> > 
>> > drivers/net/wireless/broadcom/b43/phy_a.c:576:40: error:
>> > 	'b43_phyops_a' defined but not used
>> > 
>> > Per Michael Büsch: "All a-phy code is usused", so remove it all,
>> > and move the remaining Type-G initialization code into phy_g.c.
>> > 
>> > Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
>> > Cc: Michael Büsch <m@bues.ch>
>> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>  
>> 
>> Thanks, 2 patches applied to wireless-drivers-next.git:
>> 
>> 9791333a840f b43: Remove unused phy_a code
>> afdfdc481ea9 b43: Completely remove support for phy_a
>
> Did anybody test this on any hardware? I think this should be tested
> on some G-PHY hardware, before it goes to Linus.

Larry tested these:

"These two patches have been tested on a BCM4318."

https://patchwork.kernel.org/patch/9154719/

-- 
Kalle Valo
