Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:34364 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaLXS3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 13:29:06 -0500
Message-ID: <549B05F0.9020704@broadcom.com> (sfid-20141224_192914_018055_1330C989)
Date: Wed, 24 Dec 2014 19:29:04 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: hostapd and 11h support
References: <549A8827.3070703@broadcom.com> <20141224173227.GA1969@w1.fi>
In-Reply-To: <20141224173227.GA1969@w1.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/24/14 18:32, Jouni Malinen wrote:
> On Wed, Dec 24, 2014 at 10:32:23AM +0100, Arend van Spriel wrote:
>> I am looking at 11h support in hostapd. The supplicant uses
>> .start_dfs_cac() driver callback (resulting in
>> NL08211_CMD_RADAR_DETECT) and basically the CAC logic is done in the
>> supplicant. Now for our devices the entire radar detection and CAC
>> state machine is built in firmware. So hostapd would just need to
>> enable 11h in the driver/firmware.
>>
>> I am considering a new offload feature flag, but not sure whether we
>> would need to introduce a new nl80211 command. I am thinking we
>> could just reuse .start_dfc_cac(). Because of the feature flag it
>> would have a different meaning in the driver. Wanted to know your
>> opinion on this approach before starting the work.
>
> There's already one vendor-specific mechanism for supporting such
> offloading.. Could you please check whether that would work for your
> driver as well? Search for WPA_DRIVER_FLAGS_DFS_OFFLOAD to see how the
> hostapd-based operations are skipped. This driver flag is currently set
> based on a QCA vendor specific driver capability indication.

Thanks for the info.

> I'm not sure I understood why we would use .start_dfs_cac() for a driver
> that takes care of CAC logic completely (i.e., I'd assume the driver
> would be capable of handling this automatically without additional input
> from user space). I don't really want to get N+1 different ways of doing
> DFS offloading, so if you can either use as-is or build on top of the
> existing design (without breaking it for other, obviously), that would
> be preferred.

The firmware on the device *can* have CAC logic built-in. When it *is* 
built-in it is however disabled by default. Based on your feedback I 
will just detect firmware support, enable dfs in firmware, and signal 
DFS offload to hostapd. I would suggest introducing a new common 
capability flag for this instead of using a QCA vendor specific one. 
That would be odd ;-)

Regards,
Arend
