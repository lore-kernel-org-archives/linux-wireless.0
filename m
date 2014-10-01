Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:55894 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJAIZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 04:25:49 -0400
Message-ID: <542BBA87.4080206@broadcom.com> (sfid-20141001_102600_994493_4C52F487)
Date: Wed, 1 Oct 2014 10:25:43 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Anyone working on making iw able to specify MAC address at station
 creation time?
References: <5408A6BD.6090304@candelatech.com>  (sfid-20140904_195201_728073_99DA3C67) <1409898836.1940.1.camel@jlt4.sipsolutions.net> <542AEC16.5050003@candelatech.com>
In-Reply-To: <542AEC16.5050003@candelatech.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/14 19:44, Ben Greear wrote:
> On 09/04/2014 11:33 PM, Johannes Berg wrote:
>> On Thu, 2014-09-04 at 10:51 -0700, Ben Greear wrote:
>>> I'm having issues with udev renaming newly created stations when I have
>>> udev rules for wlanX, when wlanX is not already existing.
>>>
>>> I think specifying MAC on station creation time would solve my problems,
>>> but haven't looked closely yet.
>>>
>>> My version of 'iw' doesn't support setting the MAC on creation, from
>>> what I can tel.
>>>
>>> Curious if anyone else is working on this?
>>
>> I think Marcel mentioned wanting this before. There's even an attribute
>> in nl80211 already, but it can only be used for P2P_DEVICE I believe, so
>> a feature flag or so would be needed to be able to know whether or not
>> this would be expected to take any effect (kernels before those future
>> changes would ignore the attribute for non-P2P-DEVICE I believe)
>
>  From what I can tell, cfg80211 does parse the macaddr for p2p-device,
> but I don't see it used in mac80211/iface.c ieee80211_if_add.
>
> Am I missing something?

Hi Ben,

It has been a while ago since I added this, but it could be that only 
brcmfmac is the only driver looking at the mac address parameter and 
that is a cfg80211 driver.

Regards,
Arend

--8<-----------------------------------------------------------------

commit 1c18f1452a772dfe884ed25677bddb3ecaf9c43a
Author: Arend van Spriel <arend@broadcom.com>
Date:   Tue Jan 8 10:17:27 2013 +0100

     nl80211: allow user-space to set address for P2P_DEVICE

     As per email discussion Jouni Malinen pointed out that:

     "P2P message exchanges can be executed on the current operating channel
     of any operation (both P2P and non-P2P station). These can be on 5 GHz
     and even on 60 GHz (so yes, you _can_ do GO Negotiation on 60 GHz).

     As an example, it would be possible to receive a GO Negotiation Request
     frame on a 5 GHz only radio and then to complete GO Negotiation on that
     band. This can happen both when connected to a P2P group (through 
client
     discoverability mechanism) and when connected to a legacy AP (assuming
     the station receive Probe Request frame from full scan in the beginning
     of P2P device discovery)."

     This means that P2P messages can be sent over different radio devices.
     However, these should use the same P2P device address so it should be
     able to provision this from user-space. This patch adds a parameter for
     this to struct vif_params which should only be used during creation of
     the P2P device interface.

     Cc: Jouni Malinen <j@w1.fi>
     Cc: Greg Goldman <ggoldman@broadcom.com>
     Cc: Jithu Jance <jithu@broadcom.com>
     Signed-off-by: Arend van Spriel <arend@broadcom.com>
     [add error checking]
     Signed-off-by: Johannes Berg <johannes.berg@intel.com>

  include/net/cfg80211.h | 4 ++++
  net/wireless/nl80211.c | 7 +++++++
  2 files changed, 11 insertions(+)

>>
>> Haven't looked at the code right now, this is all I know.
>>
>> johannes
>>
>
>

