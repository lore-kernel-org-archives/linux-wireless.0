Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:14901 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758532AbYGQJsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 05:48:54 -0400
Received: by an-out-0708.google.com with SMTP id d40so145849and.103
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 02:48:53 -0700 (PDT)
Message-ID: <43e72e890807170248v7a873c15oc3aea315a59e9f19@mail.gmail.com> (sfid-20080717_114910_006798_651D5A60)
Date: Thu, 17 Jul 2008 02:48:53 -0700
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH]compat-2.6: fix compiling configurations for iwlwifi
Cc: "Yingying Zhao" <yingying.zhao@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807170129w251a95f3i8eab918d50a77f97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080717081554.GA1279@amber-desktop.bj.intel.com>
	 <1ba2fa240807170129w251a95f3i8eab918d50a77f97@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2008 at 1:29 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Thu, Jul 17, 2008 at 11:15 AM, Yingying Zhao
> <yingying.zhao@linux.intel.com> wrote:
>> Latest iwlwifi in wireless-testing removed CONFIG_IWL4965_HT and
>> introduced CONFIG_IWL5000 for Intel Wireless WiFi 5000AGN support
>> which is built in IWL4965 module. This patch also enables IWLWIFI_LEDS,
>> IWLWIFI_RFKILL,IWL3945_LEDS IWLWIFI_DEBUG for iwlwifi build by default.
>>
>> Signed-off-by: Zhao Yingying <yingying.zhao@intel.com>
>> ---
>>  config.mk |   20 +++++++++++++++++++-
>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/config.mk b/config.mk
>> index b1fb68e..cafadfa 100644
>> --- a/config.mk
>> +++ b/config.mk
>> @@ -15,6 +15,7 @@ endif
>>
>>  # Wireless subsystem stuff
>>  CONFIG_MAC80211=m
>> +CONFIG_MAC80211_LEDS=y
>>
>>  # Enable QOS for 2.6.22, we'll do some hacks here to enable it.
>>  # You will need this for HT support (802.11n) and WME (802.11e).
>> @@ -77,7 +78,24 @@ CONFIG_IWLWIFI=m
>>  CONFIG_IWLCORE=m
>>  CONFIG_IWL3945=m
>>  CONFIG_IWL4965=m
>> -CONFIG_IWL4965_HT=y
>> +CONFIG_IWLWIFI_LEDS=y
>> +CONFIG_IWLWIFI_RFKILL=y
>> +CONFIG_IWL3945_LEDS=y
>> +CONFIG_IWL5000=y
>> +
>> +ifeq ($(CONFIG_IWL5000),y)
>> +ifeq ($(CONFIG_IWL4965),)
>> +$(warning "WARNING: CONFIG_IWL5000 requires CONFIG_IWL4965 is configured as m.")
>> +CONFIG_IWL4965=m
>> +endif # CONFIG_IWL4965 is empty
>> +endif # CONFIG_IWL5000 is y
>> +
>> +CONFIG_IWLWIFI_DEBUG=y
>> +
>> +ifeq ($(CONFIG_MAC80211_DEBUGFS),y)
>> +CONFIG_IWLWIFI_DEBUGFS=y
>> +endif
>> +
>>  CONFIG_B43=m
>>  # B43 uses PCMCIA only for Compact Flash. The Cardbus cards uses PCI
>>  # Example, bcm4318:
>
> I'm changing iwlwifi Kconfig so please hold this patch.

Also, was this tested with 2.6.22?

  Luis
