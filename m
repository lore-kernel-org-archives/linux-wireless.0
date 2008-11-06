Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23102.mail.ird.yahoo.com ([217.146.189.42]:38891 "HELO
	web23102.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751568AbYKFAAR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 19:00:17 -0500
Date: Thu, 6 Nov 2008 00:00:13 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <200811051936.46361.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <813803.32421.qm@web23102.mail.ird.yahoo.com> (sfid-20081106_010023_053276_83EC88EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 5/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
Tested-by Hin-Tak Leung <htl10@users.sourceforge.net>

Okay, I managed to patch compat-wireless and install it (with 2.6.27.4-24.fc9.x86_64 which has mac80211 as a module, not compiled-in).

I am having the stuck-at-1Mb problem, so rate control does not work.

Before installing compat-wireless, I think the rate started at 36Mb and moves up to 54Mb and get stuck at 54Mb as soon as any traffic is getting through; after installing the patched compat-wireless, the rate changes beteen 1Mb and 9Mb for a bit but get stuck at 1Mb as soon as any substantial traffic is getting through. I can manually switch it with "iwconfig wlan2 rate 36M", for example, but with an auto, "iwconfig wlan2 rate 36M auto", it drops back to 1Mb very soon.

Baring changes in the rest of the wireless stack (which might come to the same thing), it is probably the changes surrounding status.rate[0].count vs status.retry_count which causes the 1Mb-rate-stuck... 

Did Larry get the v2 patches to do rate-control working (i.e. the rate actually changing with demand), or not? Larry's reply was "the rate-control mechanism works the way it did before" - I am  not sure about the "it did" bit - same as v1 (rate stuck at 1Mb) or same as the prototype patch for 2.6.27 (rate changing with demand)?  

Hin-Tak



      
