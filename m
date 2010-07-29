Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43792 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0G2Jgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 05:36:51 -0400
Received: by iwn7 with SMTP id 7so148294iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 02:36:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CCA4ADC4C95A2D478B0D44E203C7370F136BF13F27@GUREXMB02.ASIAN.AD.ARICENT.COM>
References: <CCA4ADC4C95A2D478B0D44E203C7370F136BF13E18@GUREXMB02.ASIAN.AD.ARICENT.COM>
	<AANLkTim6hR9jTVXH7Ysre0Nah-8_4GyrQN2JjA2oUZcu@mail.gmail.com>
	<CCA4ADC4C95A2D478B0D44E203C7370F136BF13F27@GUREXMB02.ASIAN.AD.ARICENT.COM>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 29 Jul 2010 00:50:21 -0700
Message-ID: <AANLkTinznNvUYmL=+DQBVo5YDcCzzKLyE2Me28K4ErYB@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k mesh point not emitting beacons
To: Abhijeet Chandran <Abhijeet.Chandran@aricent.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Srivatsan Raghavan <srivatsan.raghavan@aricent.com>,
	Poonam2 Gupta <poonam2.gupta@aricent.com>,
	Manish Aggarwal <manish4.aggarwal@aricent.com>,
	Nikhil Bhatia <Nikhil.Bhatia@aricent.com>,
	Saurabh8 Jain <saurabh8.jain@aricent.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 11:50 PM, Abhijeet Chandran
<Abhijeet.Chandran@aricent.com> wrote:
>
> Hi Luis
>
> Thanks for the link . But our real problem is that the mesh interface that we are creating using iw is not behaving like a mesh point but rather like a wifi station. I have the following observations:
>
> 1. iw phy phy0 interface add mesh0 type mp mesh_id mymesh
>
>  .ieee80211_open  is called in mac80211 for interface mesh0 with type NL80211_IFTYPE_MESH_POINT
>  .Ath9k driver attaches an interface of type NL80211_IFTYPE_MESH_POINT
>  .ieee80211_stop is called in mac80211 for interface mesh0 with type NL80211_IFTYPE_MESH_POINT
>  .Ath9k  driver detached the  interface of type NL80211_IFTYPE_MESH_POINT
>  .The sdata for the interface mesh0 is flushed in mac80211.
>  .ieee80211_open  is called in mac80211 for interface mesh0 with type NL80211_IFTYPE_STATION
>  .Ath9k driver attaches an interface of type NL80211_IFTYPE_STATION .
>
> From this point on the interface behaves like a wifi station  and not as a mesh point. We have not yet figured out why the mesh interface is removed and reset to an interface of type NL80211_IFTYPE_STATION.

Javier would be the best person to review this.

 Luis

> Regards
> Abhijeet
>
> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com]
> Sent: Wednesday, July 28, 2010 9:23 PM
> To: Abhijeet Chandran
> Cc: ath9k-devel@lists.ath9k.org
> Subject: Re: [ath9k-devel] ath9k mesh point not emitting beacons
>
> On Wed, Jul 28, 2010 at 7:19 AM, Abhijeet Chandran <Abhijeet.Chandran@aricent.com> wrote:
>> Hi
>> We have a problem that we have configured a  mesh point for the first
>> time and  it  does not seem to start emitting beacons as soon as it comes up.
>> The card we are using is ath 9220
>> We brought mesh point up , ex:
>> # iw phy phy0 interface add mesh type mp mesh_id mymesh # ifconfig
>> mesh up
>>
>> Through tracing in the kernel module mac80211  it appears that a
>> callback function ieee80211_open is called with type mesh point as
>> soon as the above commands are executed.
>> However it  is immediately followed by the callback function
>> ieee80211_stop (usually called when the mesh point is brought down) ,
>> following which the meshpoint related sdata is flushed .
>> Another question that we have is that do we need to enable scanning
>> for the mesh point to emit beacons/probes?
>>
>> We have used the simulator mac80211_hwsim before  in which beacons are
>> emitted as soon as the mesh point comes up.In the simulator don't need
>> to start scanning on the mesh point.
>> We'd really appreciate if somone can help us out here.
>
> Known issue no one has yet looked into:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=14187
>
> It should start beaconing if you issue a scan.
>
>  Luis
>
> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
>
