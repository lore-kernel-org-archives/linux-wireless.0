Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:47639 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752476Ab2FKPtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 11:49:55 -0400
Message-ID: <4FD61395.8030901@xenotime.net> (sfid-20120611_174958_712219_16A49867)
Date: Mon, 11 Jun 2012 08:49:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Subject: Re: kernel-doc warnings (3.5-rc1)
References: <4FD28ED7.6070506@xenotime.net>	 (sfid-20120609_014646_473500_8E65425E) <1339229158.4539.4.camel@jlt3.sipsolutions.net> <1339229241.4539.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339229241.4539.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/09/2012 01:07 AM, Johannes Berg wrote:

> On Sat, 2012-06-09 at 10:05 +0200, Johannes Berg wrote:
>> On Fri, 2012-06-08 at 16:46 -0700, Randy Dunlap wrote:
>>> Would someone please add/fix the kernel-doc warnings?
>>
>> I'll commit the below patch for these:
> 
> D'oh.
> 
> 
> 
> mac80211: add some missing kernel-doc
> 
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add a few kernel-doc descriptions that were missed
> during development.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>



Johannes,

There are still 2 warnings from sta_info.h after applying
your patch:

Warning(net/mac80211/sta_info.h:384): No description found for parameter 't_offset_setpoint'
Warning(net/mac80211/sta_info.h:384): No description found for parameter 'ch_type'



> ---
>  include/net/mac80211.h  |    6 ++++++
>  net/mac80211/sta_info.h |    2 ++
>  2 files changed, 8 insertions(+)
> 
> --- a/include/net/mac80211.h	2012-06-09 10:04:15.000000000 +0200
> +++ b/include/net/mac80211.h	2012-06-09 10:04:19.000000000 +0200
> @@ -1945,6 +1945,11 @@ enum ieee80211_rate_control_changed {
>   *	to also unregister the device. If it returns 1, then mac80211
>   *	will also go through the regular complete restart on resume.
>   *
> + * @set_wakeup: Enable or disable wakeup when WoWLAN configuration is
> + *	modified. The reason is that device_set_wakeup_enable() is
> + *	supposed to be called when the configuration changes, not only
> + *	in suspend().
> + *
>   * @add_interface: Called when a netdevice attached to the hardware is
>   *	enabled. Because it is not called for monitor mode devices, @start
>   *	and @stop must be implemented.
> @@ -2974,6 +2979,7 @@ __le16 ieee80211_ctstoself_duration(stru
>   * ieee80211_generic_frame_duration - Calculate the duration field for a frame
>   * @hw: pointer obtained from ieee80211_alloc_hw().
>   * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + * @band: the band to calculate the frame duration on
>   * @frame_len: the length of the frame.
>   * @rate: the rate at which the frame is going to be transmitted.
>   *
> --- a/net/mac80211/sta_info.h	2012-06-09 10:04:15.000000000 +0200
> +++ b/net/mac80211/sta_info.h	2012-06-09 10:04:19.000000000 +0200
> @@ -278,6 +278,8 @@ struct sta_ampdu_mlme {
>   * @sta: station information we share with the driver
>   * @sta_state: duplicates information about station state (for debug)
>   * @beacon_loss_count: number of times beacon loss has triggered
> + * @supports_40mhz: tracks whether the station advertised 40 MHz support
> + *	as we overwrite its HT parameters with the currently used value
>   */
>  struct sta_info {
>  	/* General information, mostly static */
> 
> 
> 



-- 
~Randy
