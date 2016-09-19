Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33798 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932621AbcISSfF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 14:35:05 -0400
Received: by mail-wm0-f52.google.com with SMTP id a25so4920811wmi.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 11:35:05 -0700 (PDT)
Subject: Re: brcmfmac MAC address change delay and 500ms down delay
To: Dan Williams <dcbw@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1473950537.25907.8.camel@redhat.com>
 <f1912b3a-80ce-097f-8c58-cfe246804055@broadcom.com>
 <1474296520.3075.7.camel@redhat.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1d8981ac-2d95-a438-4285-035f191435fd@broadcom.com> (sfid-20160919_203511_992242_3AE61BC6)
Date: Mon, 19 Sep 2016 20:34:46 +0200
MIME-Version: 1.0
In-Reply-To: <1474296520.3075.7.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-9-2016 16:48, Dan Williams wrote:
> On Fri, 2016-09-16 at 11:58 +0200, Arend Van Spriel wrote:
>> On 15-9-2016 16:42, Dan Williams wrote:
>>>
>>> Hi,
>>>
>>> While refining NetworkManager's MAC address randomization behavior
>>> we
>>> came across two issues with brcmfmac:
>>>
>>> 1) when changing the MAC address, the driver schedules work for the
>>> new
>>> change and returns success, but doesn't actually change the MAC
>>> until
>>> the work is scheduled.  Because it returns 0 from the
>>> ndo_set_mac_address hook the net core will generate a
>>> NETDEV_CHANGEADDR
>>> event and rtnetlink will send out an RTM_NEWLINK with the old MAC
>>> address.  No event for the new address will be sent.  So it's
>>> pretty
>>> hard to figure out when the address actually changed, and when its
>>> safe
>>> to associate, without polling the device's MAC address.  Ugly.
>> And apparently unnecessary. I recalled we had this as the
>> ndo_set_mac_address callback could be called in atomic context. So we
>> are using a worker because we are grabbing a mutex upon sending the
>> control info to the device. Looking into the core network code it
>> seems
>> the callback is not called in atomic context so it seems we can get
>> rid
>> of the worker here. I made a patch
>>
>>>
>>> 2) when closing the device (eg, set !IFF_UP) the driver
>>> unconditionally
>>> blocks for 500ms in __brcmf_cfg80211_down():
>>>
>>> 	if (check_vif_up(ifp->vif)) {
>>> 		brcmf_link_down(ifp->vif, WLAN_REASON_UNSPECIFIED);
>>>
>>> 		/* Make sure WPA_Supplicant receives all the event
>>> 		   generated due to DISASSOC call to the fw to keep
>>> 		   the state fw and WPA_Supplicant state consistent
>>> 		 */
>>> 		brcmf_delay(500);
>>> 	}
>> This is actually a bogus delay as we are under an RTNL lock here so I
>> think the events will not go out until after the delay has finished.
>> I
>> did submit a patch long ago removing this delay, but the change was
>> not
>> accepted. Let me revisit that.
>>
>>>
>>> Should I dump these into kernel bugzilla, or is there some internal
>>> bug
>>> tracker they could get stuffed into?
>> Kernel bugzilla is fine although I check it rather infrequently.
> 
> Thanks for taking another look at these.  Should I still file in
> bugzilla, or are the patches going through the process already?

For the mac address delay I let this [1] one fly today. A pity
git-send-email does not add the 'Reported-by:' email to the Cc:

The other one is a bit more tricky. The 500ms delay can be removed, but
I need to fix a related scenario. Working on it.

Regards,
Arend

[1] 1474283399-14385-6-git-send-email-arend.vanspriel@broadcom.com
