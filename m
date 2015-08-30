Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbbH3SlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2015 14:41:15 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<55E289A3.6030001@lwfinger.net>
Date: Sun, 30 Aug 2015 14:41:09 -0400
In-Reply-To: <55E289A3.6030001@lwfinger.net> (Larry Finger's message of "Sat,
	29 Aug 2015 23:42:11 -0500")
Message-ID: <wrfjegik8vqy.fsf@redhat.com> (sfid-20150830_204118_738468_90BF8866)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 08/29/2015 04:18 PM, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> This is an alternate driver for a number of Realtek WiFi USB devices,
>> including RTL8723AU, RTL8188CU, RTL8188RU, RTL8191CU, and RTL8192CU.
>> It was written from scratch utilizing the Linux mac80211 stack.
>>
>> After spending months cleaning up the vendor provided rtl8723au
>> driver, which comes with it's own 802.11 stack included, I decided to
>> rewrite this driver from the bottom up.
>>
>> Many thanks to Johannes Berg for 802.11 insights and help and Larry
>> Finger for help with the vendor driver.
>>
>> The full git log for the development of this driver can be found here:
>> git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>>      branch rtl8723au-mac80211
>>
>> This driver is still under development, but has proven to be very
>> stable for me. It currently supports station mode only. It has support
>> for OFDM and CCK rates, as well as AMPDU. It does lack certain
>> features found in the staging driver, such as power management and
>> 40MHz channel support. In addition it does not support AD-HOC, AP, and
>> monitor mode support at this point.
>>
>> The driver is known to work with the following devices:
>> Lenovo Yoga (rtl8723au)
>> TP-Link TL-WN823N (rtl8192cu)
>> Etekcity 6R (rtl8188cu)
>> Daffodil LAN03 (rtl8188cu)
>> Alfa AWUS036NHR (rtl8188ru)
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> I did not realize you were resubmitting this driver so soon. I have
> been accumulating some patches that I was going to send to you in the
> next couple of days. The most important of these are described inline
> below.

Thanks - I already ran it through checkpatch, there is nothing from
checkpatch that needs to be resolved.

>> +
>> +static int rtl8xxxu_debug = 0;
>
> Checkpatch reports:
>
> ERROR: do not initialise statics to 0 or NULL
> #106: FILE: drivers/net/wireless/rtl8xxxu.c:45:
> +static int rtl8xxxu_debug = 0;

I really hate these pointless checkpatch warnings, but I guess I should
just post the 0 in comments to not have to waste time on people
submitting patches for this.

>> +	dev_info(&priv->udev->dev, "%s: dumping efuse (0x%02lx bytes):\n",
>> +		 __func__, sizeof(struct rtl8192cu_efuse));
>
> On a 32-bit PowerPC, the above line outputs the following:
>
> warning: format ‘%lx’ expects argument of type ‘long unsigned int’,
> but argument 4 has type ‘unsigned int’ [-Wformat]
>
> This issue does not affect the object code, but it should be
> fixed. Setting the format specifier to %02x and adding a cast of (int)
> before the "size_of" will fix it on both sets of systems.

Ewww, I didn't realize PowerPC 32 was this ugly :( Adding (long) as a
cast would have the same effect here, but we will end up with an ugly
cast in either case.

>> +static void rtl8723a_phy_lc_calibrate(struct rtl8xxxu_priv *priv)
>> +{
>> +	u32 val32;
>> +	u32 rf_amode, rf_bmode = 0, lstf;
>> +
>> +	/* Check continuous TX and Packet TX */
>> +	lstf = rtl8xxxu_read32(priv, REG_OFDM1_LSTF);
>> +
>> +	if (lstf & OFDM_LSTF_MASK) {
>> +		/* Disable all continuous TX */
>> +		val32 = lstf & ~OFDM_LSTF_MASK;
>> +		rtl8xxxu_write32(priv, REG_OFDM1_LSTF, val32);
>> +
>> +		/* Read original RF mode Path A */
>> +		rf_amode = rtl8xxxu_read_rfreg(priv, RF_A, RF6052_REG_AC);
>
> The compiler on the PPC system (V4.6.3) is not as good at determining
> if a variable has been set as is V4.8.3. It generates the warning
> "warning: ‘rf_amode’ may be used uninitialized in this function
> [-Wuninitialized]" for the above statement. As I hate to initialize
> any variable that does not need it, this one should probably be left
> alone; however, you may wish to add a comment.

A comment would suffice, but the question is really whether it adds
value to the code doing so - since 99.99% of users will never see this
compiler warning. I am not opposed to zero initializing it, as I had to
do the same with rf_bmode.

>> +static void rtl8xxxu_tx(struct ieee80211_hw *hw,
>> +			struct ieee80211_tx_control *control,
>> +			struct sk_buff *skb)
>> +{
>> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>> +	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
>> +	struct ieee80211_rate *tx_rate = ieee80211_get_tx_rate(hw, tx_info);
>> +	struct rtl8xxxu_priv *priv = hw->priv;
>> +	struct rtl8xxxu_tx_desc *tx_desc;
>> +	struct ieee80211_sta *sta = NULL;
>> +	struct rtl8xxxu_sta_priv *sta_priv = NULL;
>> +	struct device *dev = &priv->udev->dev;
>> +	struct urb *urb;
>> +	u32 queue, rate;
>> +	u16 pktlen = skb->len;
>> +	u16 seq_number;
>> +	u16 rate_flag = tx_info->control.rates[0].flags;
>> +	int ret;
>> +
>> +	if (skb_headroom(skb) < sizeof(struct rtl8xxxu_tx_desc)) {
>> +		dev_warn(dev,
>> +			 "%s: Not enough headroom (%i) for tx descriptor\n",
>> +			 __func__, skb_headroom(skb));
>> +		goto error;
>> +	}
>> +
>> +	if (unlikely(skb->len > (65535 - sizeof(struct rtl8xxxu_tx_desc)))) {
>> +		dev_warn(dev, "%s: Trying to send over-sized skb (%i)\n",
>> +			 __func__, skb->len);
>> +		goto error;
>> +	}
>> +
>> +	urb = usb_alloc_urb(0, GFP_KERNEL);
>
> The above statement generated a "scheduling while atomic" splat. The
> gfp_t argument needs to be GFP_KERNEL.

You are seeing scheduling while atomic in the TX path? That just seems
wrong to me - Johannes is the mac80211 TX path not meant to allow
sleeping?

I have never seen this on x86 and I have been running the driver for a
long time. It is puzzling this causes a problem on PowerPC. It there
something special in the config for it? I am inclined to say there is
something wrong with the PPC32 setup rather than with my usage of
GFP_KERNEL in the TX path.

>> +{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x817e, 0xff,
> 0xff, 0xff),
>> +	.driver_info = (unsigned long)&rtl8192cu_fops},
>
> I have tested a device with USB ID 0x0bda (USB_VENDOR_ID_REALTEK):0x817e.

Were you happy with the results, or did it cause problems? Ie. did you
try on x86 or on PPC32?

> Some comments that are not part of the review, but may be of interest
> to potential users:
>
> 1. The gain settings on the RTL81{88,92}CU parts greatly reduce its
> usefullnes. My Edimax 7811 can only find 1 of my 5 local APs in a
> scan. It can connect to that AP, but achieves less than 10 Mbps for
> both RX and TX operations. I expect to be able to discover better
> initialization variables, but that may take a while.

Interesting, I am trying to use the settings coming out of the efuse,
but it is not impossible I do something wrong with them. So far I got
decent results with 8192cu devices, But my testing with those has been
limited.

> 2. The driver fails to produce a wireless device on the PowerPC
> because the firmware ready to run bit is never set. I have not seen
> any reason for this to be a big-endian issue, and it may be another
> pecularity of the USB subsystem on that laptop. For example, USB
> devices that are plugged in at boot time fail, even though they work
> if hot plugged into a running system.
>
> For a new driver written from scratch, it looks pretty good.

Thanks for the comments, much appreciated!

I don't think any of this is showstopper material for inclusion right
now, albeit I do want to address them.

Cheers,
Jes
