Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:41585 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757672Ab0ICVwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 17:52:43 -0400
Message-ID: <4C816E18.6050408@redfish-solutions.com>
Date: Fri, 03 Sep 2010 14:52:24 -0700
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Subject: Re: Marshaling issues w/ compat-wireless-2010-08-19
References: <4C746F74.70401@redfish-solutions.com> <20100828171239.GA23885@jm.kir.nu> <4C79450C.80507@redfish-solutions.com> <4C7C55E6.1060707@redfish-solutions.com>
In-Reply-To: <4C7C55E6.1060707@redfish-solutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  On 8/30/10 6:07 PM, Philip Prindeville wrote:
>  On 8/28/10 10:19 AM, Philip Prindeville wrote:
>>  On 8/28/10 11:12 AM, Jouni Malinen wrote:
>>> On Tue, Aug 24, 2010 at 06:18:44PM -0700, Philip Prindeville wrote:
>>>>   I've got a stock Fedora Core 13 install (updated today) with the hostapd-0.6.10 rpm and hostapd-0.7.2 compiled from sources.  The NIC is a Ubiquiti SR71e (AR9280).
>>>> (2) Some highly unlikely values from the hostapd debugging messages when parsing out WEP authentication messages (line 507):
>>>> authentication: STA=f8:1e:df:1e:c2:23 auth_alg=35510 auth_transaction=79 status_code=21688 wep=1
>>>> Unsupported authentication algorithm (35510)
>>> I was unable to reproduce this with the current development tree
>>> snapshots. Shared key authentication worked with AR9280 and the current
>>> wireless-testing.git and hostap.git in my tests. If you are still seeing
>>> this, you could also try to disable hw crypto to remove one possible
>>> issue area by using nohwcrypt=1 module parameter when loading ath9k.
>>>
>>
>> Already tried that, and it didn't help.
>>
>> -Philip
>
> I also tried with the tarballs from 2010-07-19, and 2010-08-29 and saw the same issue.
>
> I also was able to reproduce the issue with "nohwcrypt=1".
>
> So I'm wondering what if decryption is working fine, but the buffer has an alignment issue or isn't being marshaled into netlink properly?
>
> -Philip

Just following up: I isolated the problem.

I had taken the sample hostapd.conf that comes with hostapd-0.7.2 and copied it into /etc/.

Then I enabled the following commented out fields:

bridge=br0
driver=nl80211
ssid=my-hp-test
country_code=US
hw_mode=g
channel=10
wep_default_key=0
wep_key0=123456789a
ieee80211n=1

but what broke it was:

wep_key_len_broadcast=5
wep_key_len_unicast=5
wep_rekey_period=300

if I turned off those last 3, things work again.  Note also that using "nohwcrypt=1" didn't affect anything.

