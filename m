Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:38958 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187Ab0IDWpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Sep 2010 18:45:51 -0400
Message-ID: <4C82CC10.7060903@redfish-solutions.com>
Date: Sat, 04 Sep 2010 15:45:36 -0700
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Subject: Re: Marshaling issues w/ compat-wireless-2010-08-19
References: <4C746F74.70401@redfish-solutions.com>	 <20100828171239.GA23885@jm.kir.nu> <4C79450C.80507@redfish-solutions.com>	 <4C7C55E6.1060707@redfish-solutions.com>	 <4C816E18.6050408@redfish-solutions.com> <1283589824.3746.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1283589824.3746.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  On 9/4/10 1:43 AM, Johannes Berg wrote:
> On Fri, 2010-09-03 at 14:52 -0700, Philip Prindeville wrote:
>
>> Just following up: I isolated the problem.
>>
>> I had taken the sample hostapd.conf that comes with hostapd-0.7.2 and copied it into /etc/.
>>
>> Then I enabled the following commented out fields:
>>
>> bridge=br0
>> driver=nl80211
>> ssid=my-hp-test
>> country_code=US
>> hw_mode=g
>> channel=10
>> wep_default_key=0
>> wep_key0=123456789a
>> ieee80211n=1
>>
>> but what broke it was:
>>
>> wep_key_len_broadcast=5
>> wep_key_len_unicast=5
>> wep_rekey_period=300
>>
>> if I turned off those last 3, things work again.
> Hah. I don't even know what that does. What were you trying to achieve?
> Aren't those related to dynamic WEP, but you configured static WEP?
>
> johannes
>

I was trying to test the rekeying feature, where new keys are multicast when the group membership changes.


