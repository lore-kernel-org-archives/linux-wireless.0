Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f42.google.com ([209.85.213.42]:42641 "EHLO
	mail-yw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2GMDOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 23:14:21 -0400
Received: by yhoo21 with SMTP id o21so2838648yho.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 20:14:20 -0700 (PDT)
Message-ID: <4FFF927D.7020106@lwfinger.net> (sfid-20120713_051459_990030_AB8113FF)
Date: Thu, 12 Jul 2012 22:14:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Anyone using rtl8192de with 2.4GHz 802.11g?
References: <20120712002149.GA14850@alittletooquiet.net> <4FFE211C.3020506@lwfinger.net> <20120712013216.GB14850@alittletooquiet.net> <4FFE2F38.7030604@lwfinger.net> <20120712152545.GA9489@alittletooquiet.net> <4FFEF9F8.5060106@lwfinger.net> <20120712181751.GB9489@alittletooquiet.net> <20120712210703.GC9489@alittletooquiet.net> <20120712215730.GD9489@alittletooquiet.net>
In-Reply-To: <20120712215730.GD9489@alittletooquiet.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2012 04:57 PM, Forest Bond wrote:
> Hi Larry,
>
> On Thu, Jul 12, 2012 at 05:07:03PM -0400, Forest Bond wrote:
>> On Thu, Jul 12, 2012 at 02:17:51PM -0400, Forest Bond wrote:
>>> On Thu, Jul 12, 2012 at 11:23:20AM -0500, Larry Finger wrote:
>>>> On 07/12/2012 10:25 AM, Forest Bond wrote:
>>>>> On Wed, Jul 11, 2012 at 08:58:16PM -0500, Larry Finger wrote:
>>>>>> On 07/11/2012 08:32 PM, Forest Bond wrote:
>>>>>>> On Wed, Jul 11, 2012 at 07:58:04PM -0500, Larry Finger wrote:
>>>>>>>> On 07/11/2012 07:21 PM, Forest Bond wrote:
>>>>>>>>> The rtl8192de driver is working fine for me at 5GHz, but I am having trouble
>>>>>>>>> getting scan results for 2.4GHz 802.11g networks.  I have been doing a lot of
>>>>>>>>> debugging but am not making much progress.  I suspect the 802.11 b/g/n phy is
>>>>>>>>> not being initialized correctly, but I'm pretty far outside my domain on this
>>>>>>>>> one.
>>>>>>>>>
>>>>>>>>> Is anyone successfully using this driver with a 2.4GHz 802.11g network?
>>>>>>>>
>>>>>>>> I have several different models - some work better than others. What
>>>>>>>> is the PCI ID for yours?
>>>>>>>
>>>>>>> This is the one I have:
>>>>>>>
>>>>>>> 02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [10ec:8193]
>>>>>>> 02:00.1 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [10ec:8193] (rev 01)
>>>>>>
>>>>>> It turns out that both kinds have the same ID. I think one of them
>>>>>> is a prototype, while the other is probably a production unit.
>>>>>> Obviously, bitrot has set in while I wasn't testing. With the kernel
>>>>>> driver, neither unit can even scan in the 2.4 GHz band. Using the
>>>>>> latest version of the vendor driver, the production version connects
>>>>>> with APs running WEP, WPA, or WPA2. The prototype can only handle
>>>>>> WEP.
>>>>>>
>>>>>> Obviously, I have some work to do. In the meantime, I will send you
>>>>>> a tarball containing the vendor driver - privately so as not to spam
>>>>>> the list.
>>>>>
>>>>> Thank you, I appreciate that.
>>>>>
>>>>> Of course, my preference would be to fix up the kernel driver.  I don't mind
>>>>> doing some manual bisection with compat-wireless releases unless you think that
>>>>> would be a total waste of time.  Do you have any sense for what the last working
>>>>> kernel version would have been?
>>>>>
>>>>> As you suggest, we may need to use the vendor driver in the meantime.  Thanks
>>>>> again for sending it over (although I suspect it is the same version I
>>>>> downloaded from Realtek's web site).
>>>>
>>>> It started with the Realtek version, but has some important bug
>>>> fixes that I wanted you to have.
>>>
>>> Thanks, that's really helpful.
>>>
>>>> Of course, we want to fix the kernel version, but if you want to
>>>> bisect compat-wireless, that would be a big help. In the meantime, I
>>>> will try bisecting wireless-testing when I get a chance.
>>>
>>> I have begun disecting compat-wireless releases.  3.1.1-1 works, 3.2.5-1
>>> doesn't.  I'm going to try to identify the commit that broke things by applying
>>> patches to 3.1.1-1.
>>
>> So unless I screwed something up while bisecting, I think this is where things
>> broke:
>>
>>
>> commit d83579e2a50ac68389e6b4c58b845c702cf37516
>> Author: Chaoming Li <chaoming_li@realsil.com.cn>
>> Date:   Tue Oct 11 21:28:51 2011 -0500
>>
>>      rtlwifi: rtl8192de: Updates from latest Reaktek driver - Part III
>>
>>      This patch incorporate the differences between the 06/20/2011 and
>>      08/16/2011 Realtek releases of the rtl8192de driver.
>>
>>      The changes include:
>>
>>      1. Update for new chip versions
>>
>>      Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
>>      Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>      Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>
>>
>> I managed to get into an interesting situation at one point during testing where
>> neither MAC would return scan results, even after reverting to a known-good
>> driver version.  This was resolved by removing and re-applying power (i.e. a
>> reboot did not fix it).  Something must've put the hardware in a bad state.  I
>> haven't seen this problem again.
>>
>> Anyway, I'll probably play with that patch a bit to see if I can figure out what
>> broke, but let me know if you have any ideas.
>
>
> So this seems to fix things:
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> index 18380a7..be21c81 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> @@ -3345,21 +3345,25 @@ void rtl92d_phy_config_macphymode_info(struct ieee80211_hw *hw)
>   	switch (rtlhal->macphymode) {
>   	case DUALMAC_SINGLEPHY:
>   		rtlphy->rf_type = RF_2T2R;
> -		rtlhal->version |= CHIP_92D_SINGLEPHY;
> +		/*rtlhal->version |= CHIP_92D_SINGLEPHY;*/
> +		rtlhal->version |= RF_TYPE_2T2R;
>   		rtlhal->bandset = BAND_ON_BOTH;
>   		rtlhal->current_bandtype = BAND_ON_2_4G;
>   		break;
>
>   	case SINGLEMAC_SINGLEPHY:
>   		rtlphy->rf_type = RF_2T2R;
> -		rtlhal->version |= CHIP_92D_SINGLEPHY;
> +		/*rtlhal->version |= CHIP_92D_SINGLEPHY;*/
> +		rtlhal->version |= RF_TYPE_2T2R;
>   		rtlhal->bandset = BAND_ON_BOTH;
>   		rtlhal->current_bandtype = BAND_ON_2_4G;
>   		break;
>
>   	case DUALMAC_DUALPHY:
>   		rtlphy->rf_type = RF_1T1R;
> -		rtlhal->version &= (~CHIP_92D_SINGLEPHY);
> +		/*rtlhal->version &= (~CHIP_92D_SINGLEPHY);*/
> +		rtlhal->version &= RF_TYPE_1T1R;
> +
>   		/* Now we let MAC0 run on 5G band. */
>   		if (rtlhal->interfaceindex == 0) {
>   			rtlhal->bandset = BAND_ON_5G;
>
>
> And this is unrelated, but also seems important:
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> index b338d52..59e85f5 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> @@ -1058,11 +1058,14 @@ static enum version_8192d _rtl92de_read_chip_version(struct ieee80211_hw *hw)
>   	u32 value32;
>
>   	value32 = rtl_read_dword(rtlpriv, REG_SYS_CFG);
> +	version |= CHIP_92D;
> +
>   	if (!(value32 & 0x000f0000)) {
>   		version = VERSION_TEST_CHIP_92D_SINGLEPHY;
>   		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "TEST CHIP!!!\n");
>   	} else {
> -		version = VERSION_NORMAL_CHIP_92D_SINGLEPHY;
> +		/*version = VERSION_NORMAL_CHIP_92D_SINGLEPHY;*/
> +		version |= NORMAL_CHIP;
>   		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Normal CHIP!!!\n");
>   	}
>   	return version;
>
>
> Let me know what you think.  I can prepare some proper patches sometime
> tomorrow.

All of those match the code in the 0816.2011 driver. I have no idea what went 
wrong earlier, but I think those patches are OK.

Larry

