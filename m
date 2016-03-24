Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34925 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbcCXKEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 06:04:42 -0400
Subject: Re: [PATCH 2/2] wil6210: add module parameter for alternate interface
 name
To: Kalle Valo <kvalo@codeaurora.org>,
	Maya Erez <qca_merez@qca.qualcomm.com>
References: <1458590472-677-1-git-send-email-qca_merez@qca.qualcomm.com>
 <1458590472-677-3-git-send-email-qca_merez@qca.qualcomm.com>
 <87y499dxjf.fsf@kamboji.qca.qualcomm.com>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
From: Lior David <liord@codeaurora.org>
Message-ID: <56F3BBB4.6030104@codeaurora.org> (sfid-20160324_110446_078114_5E73CC0E)
Date: Thu, 24 Mar 2016 12:04:36 +0200
MIME-Version: 1.0
In-Reply-To: <87y499dxjf.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/23/2016 5:27 PM, Kalle Valo wrote:
> Maya Erez <qca_merez@qca.qualcomm.com> writes:
> 
>> From: Lior David <qca_liord@qca.qualcomm.com>
>>
>> Add a module parameter alt_ifname that when set, will name
>> the primary network interface wigig<N> instead of the default
>> wlan<N>. This helps platforms such as android where we need to
>> clearly separate the WIGIG interface from the default wireless
>> interface.
>>
>> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
>> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/wil6210/netdev.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
>> index 3bc0e26..f78ea91 100644
>> --- a/drivers/net/wireless/ath/wil6210/netdev.c
>> +++ b/drivers/net/wireless/ath/wil6210/netdev.c
>> @@ -14,10 +14,15 @@
>>   * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>>   */
>>  
>> +#include <linux/moduleparam.h>
>>  #include <linux/etherdevice.h>
>>  #include "wil6210.h"
>>  #include "txrx.h"
>>  
>> +static bool alt_ifname; /* = false; */
>> +module_param(alt_ifname, bool, S_IRUGO);
>> +MODULE_PARM_DESC(alt_ifname, " use an alternate interface name wigigN instead of wlanN");
>> +
>>  static int wil_open(struct net_device *ndev)
>>  {
>>  	struct wil6210_priv *wil = ndev_to_wil(ndev);
>> @@ -136,6 +141,7 @@ void *wil_if_alloc(struct device *dev)
>>  	struct wil6210_priv *wil;
>>  	struct ieee80211_channel *ch;
>>  	int rc = 0;
>> +	const char *ifname = alt_ifname ? "wigig%d" : "wlan%d";
>>  
>>  	wdev = wil_cfg80211_init(dev);
>>  	if (IS_ERR(wdev)) {
>> @@ -160,7 +166,7 @@ void *wil_if_alloc(struct device *dev)
>>  	ch = wdev->wiphy->bands[IEEE80211_BAND_60GHZ]->channels;
>>  	cfg80211_chandef_create(&wdev->preset_chandef, ch, NL80211_CHAN_NO_HT);
>>  
>> -	ndev = alloc_netdev(0, "wlan%d", NET_NAME_UNKNOWN, wil_dev_setup);
>> +	ndev = alloc_netdev(0, ifname, NET_NAME_UNKNOWN, wil_dev_setup);
>>  	if (!ndev) {
>>  		dev_err(dev, "alloc_netdev_mqs failed\n");
>>  		rc = -ENOMEM;
> 
> To me this looks like an ugly hack and I hope there is a better way to
> handle the problem this patch is fixing. I think interface names
> shouldn't matter from functionality point of view, anything requiring
> certain naming is broken.
> 
> But if the interface name is so important why not use "wigig%d" always?
> The user space can rename the interface name anyway.

The problem we try to solve is with Android. Android uses hard-coded "wlan0"
interface name for wifi. We have a platform where wigig(11ad) is used
alongside wifi(11ac). Both are independent and managed by separate services,
but started at boot at roughly the same time. Sometimes 11ad will get wlan0
interface name and 11ac will get wlan1, and wifi will not work.
We considered using "wigig%d" always as you suggested, but it may break an
unknown number of existing tools/scripts that rely on wlan0 interface name.

As I see it, it is an issue of classification. Network drivers use a default
interface name prefix depending on the device type. Ethernet drivers get "eth%d",
wireless drivers get "wlan%d" and so on. There are even existing drivers
that give different prefixes based on other conditions, for example see
drivers/s390/net/ctcm_main.c, ctcm_init_netdevice.
For our 11ad device, in many platforms it is used as a wifi replacement, so
the wlan%d name is appropriate, in other platforms it is used as
a different wireless device for different purposes, so the default "wigig%d"
prefix seems appropriate.

Thanks,
Lior

