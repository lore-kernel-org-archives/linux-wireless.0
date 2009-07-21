Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:53213 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548AbZGUULq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 16:11:46 -0400
Message-ID: <4A6620B9.4@redfish-solutions.com>
Date: Tue, 21 Jul 2009 13:10:33 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Subject: Re: Using compat-wireless w/ 2.6.27.26
References: <4A612514.4050708@redfish-solutions.com> <b6c5339f0907190638jc1bdacbo801adcd39a1cf5@mail.gmail.com> 	<4A635E04.4050204@redfish-solutions.com> <20090719203150.GA9972@hash.localnet> 	<4A63DF0B.4010801@redfish-solutions.com> <20090720115244.GC9972@hash.localnet> 	<4A64C283.6090205@redfish-solutions.com> <43e72e890907201247x7df76b75wf6ba2bc2260dbf7a@mail.gmail.com> <4A650331.9020409@redfish-solutions.com>
In-Reply-To: <4A650331.9020409@redfish-solutions.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Philip A. Prindeville wrote:
> Luis R. Rodriguez wrote:
>   
>> On Mon, Jul 20, 2009 at 12:16 PM, Philip A.
>> Prindeville<philipp_subx@redfish-solutions.com> wrote:
>>     
>>> Bob Copeland wrote:
>>>       
>>>> On Sun, Jul 19, 2009 at 08:05:47PM -0700, Philip A. Prindeville wrote:
>>>>         
>>>>> Actually, it's saying:
>>>>>
>>>>> filename:       /lib/modules/2.6.27.26-astlinux/kernel/drivers/net/wireless/ath5k/ath5k.ko
>>>>> depends:        mac80211,cfg80211
>>>>>
>>>>> And the 0.6.0 version number matches ath5k/base.c in the compat-wireless
>>>>> sources as well.
>>>>>           
>>>> Yeah, ignore the module version number, no one ever changes it.
>>>>
>>>>         
>>>>> Not seeing the dependency on "ath", which is strange.  Is that common code
>>>>> that's shared in 2.6.30 for the Atheros drivers?
>>>>>           
>>>> In 2.6.31, yes.
>>>>
>>>>         
>>>>>> The fix was merged after 2.6.30, IIRC, but it should definitely be in
>>>>>> compat-wireless.  Also check your modules directory for an old ath5k.ko
>>>>>> sitting in drivers/.../wireless/ath5k.  It should now be in ath/ath5k.
>>>>>>             
>>>> See above, the fix was post-2.6.30, however compat-wireless should have
>>>> it.  The module should now be in drivers/net/wireless/ath/ath5k, not
>>>> drivers/net/wireless/ath5k.
>>>>
>>>>         
>>> I'm using the tarball out of:
>>>
>>> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.30
>>>
>>> perhaps I should be using a different one?  I tried 2.6.31-rc1, but it doesn't build against 2.6.27.
>>>       
>> I have to fix this, will do so in a bit, will also update it to
>> account for the new rc3.
>>
>>   Luis
>>     
>
> Well, while waiting for a "blessed" (or at least, 'stable') tarball to be pushed out, I tried running 2009-06-30, and I'm seeing a lot of:
>
> mgmt::proberesp cb
> Probe Request from 00:21:29:69:3e:a0 for broadcast SSID ignored
> STA 00:21:29:69:3e:a0 sent probe request for our SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
> Probe Request from 00:21:e9:6e:a7:4f for broadcast SSID ignored
> Probe Request from 00:21:e9:6e:a7:4f for broadcast SSID ignored
> Probe Request from 00:21:e9:6e:a7:4f for broadcast SSID ignored
> ...
> STA 00:21:e9:6e:a7:4f sent probe request for our SSID
> MGMT (TX callback) ACK
> mgmt::proberesp cb
> STA 00:21:e9:6e:a7:4f sent probe request for our SSID
> MGMT (TX callback) ACK
> mgmt::proberesp cb
> STA 00:21:e9:6e:a7:4f sent probe request for our SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
> STA 00:21:e9:6e:a7:4f sent probe request for our SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
> STA 00:21:e9:6e:a7:4f sent probe request for our SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
> STA 00:21:e9:6e:a7:4f sent probe request for our SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
> STA 00:21:e9:6e:a7:4f sent probe request for our SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
> STA 00:21:e9:6e:a7:4f sent probe request for our SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
> Probe Request from 00:21:e9:6e:a7:4f for broadcast SSID ignored
> Probe Request from 00:21:e9:6e:a7:4f for broadcast SSID ignored
> Probe Request from 00:21:e9:6e:a7:4f for broadcast SSID ignored
> Probe Request from 00:21:e9:6e:a7:4f for broadcast SSID ignored
> Probe Request from 00:21:e9:6e:a7:4f for broadcast SSID ignored
> Probe Request from 00:21:e9:6e:a7:4f for broadcast SSID ignored
> STA 00:21:29:69:3e:a0 sent probe request for our SSID
> Probe Request from 00:21:29:69:3e:a0 for broadcast SSID ignored
> MGMT (TX callback) ACK
> mgmt::proberesp cb
> STA 00:21:29:69:3e:a0 sent probe request for our SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
>
>
>
> 00:21:29:69:3e:a0 is a PC running Vista SP2.
>
> 00:21:e9:6e:a7:4f is an iPhone running 3.0.
>
> The iPhone should be scanning for available networks, but it's also been explicitly configured with this particular AP (and SSID).
>
> Is this a known issue?
>
> -Philip
>   

A little progress:  I build 2009-07-10 with 2.6.27.26, and I can get the
Vista box to associate, but not an iPhone running 3.0...

I have traces if anyone is interested.

-Philip

