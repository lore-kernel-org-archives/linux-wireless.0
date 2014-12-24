Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58965 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaLXUkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 15:40:12 -0500
Message-ID: <549B24A9.4080001@broadcom.com> (sfid-20141224_214016_714216_DDC0BD4C)
Date: Wed, 24 Dec 2014 21:40:09 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>
Subject: Re: hostapd and 11h support
References: <549A8827.3070703@broadcom.com> <20141224173227.GA1969@w1.fi> <549B05F0.9020704@broadcom.com> <20141224190452.GA6933@w1.fi>
In-Reply-To: <20141224190452.GA6933@w1.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/24/14 20:04, Jouni Malinen wrote:
> On Wed, Dec 24, 2014 at 07:29:04PM +0100, Arend van Spriel wrote:
>> The firmware on the device *can* have CAC logic built-in. When it
>> *is* built-in it is however disabled by default. Based on your
>> feedback I will just detect firmware support, enable dfs in
>> firmware, and signal DFS offload to hostapd. I would suggest
>> introducing a new common capability flag for this instead of using a
>> QCA vendor specific one. That would be odd ;-)
>
> I see nothing odd in other drivers using the already defined QCA vendor
> specific nl80211 command. Anyway, I have no issues with a new nl80211
> capability flag added for this purpose. You'll probably have better
> chances of getting that accepted with an upstream driver using it.

Maybe not odd but counter-intuitive to some people. Anyway, I was 
looking at the code in driver_nl80211_capa.c and stumbled upon 
WPA_DRIVER_FLAGS_KEY_MGMT_OFFLOAD. I introduced entensible feature flags 
upstream just yesterday to accomodate this type of offload. Just curious 
but are those QCA vendor specific nl80211 commands used by the upstream 
QCA drivers or is this for supporting QCA proprietary drivers. I guess 
the latter as that would be the only reason I can think of to have 
vendor specific commands.

Regards,
Arend
