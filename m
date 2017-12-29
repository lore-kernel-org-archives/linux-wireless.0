Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:46575 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdL2S3Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 13:29:25 -0500
Received: by mail-it0-f45.google.com with SMTP id c16so7628215itc.5
        for <linux-wireless@vger.kernel.org>; Fri, 29 Dec 2017 10:29:25 -0800 (PST)
Subject: Re: [RFC 0/4] EAPoL over NL80211
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
References: <20171228175832.3253-1-denkenz@gmail.com>
 <5A460B01.7060603@broadcom.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <186d4469-fffb-45b2-1ea7-53a4eaf1c966@gmail.com> (sfid-20171229_192937_701953_D7DF1E5F)
Date: Fri, 29 Dec 2017 12:29:23 -0600
MIME-Version: 1.0
In-Reply-To: <5A460B01.7060603@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

<snip>

>> To make this possible this patchset introduces a new NL80211 command 
>> and several
>> new attributes.  A userspace that is capable of processing EAPoL 
>> packets over
>> NL80211 includes a new NL80211_ATTR_CONTROL_PORT_OVER_NL80211 
>> attribute in its
>> NL80211_CMD_ASSOCIATE or NL80211_CMD_CONNECT requests being sent to 
>> the kernel.
>> The previously added NL80211_ATTR_SOCKET_OWNER attribute must also be 
>> included.
> 
> Does it make sense to require a combination of attributes. It is always 
> a bit awkward so prefer to avoid it. Could we implicitly make the 
> netlink unicast for notifications when 
> NL80211_ATTR_CONTROL_PORT_OVER_NL80211 is provided by user-space.
> 

Agreed, requiring both attributes is less than ideal, but I tried to 
make the initial RFC as minimal as possible.  It also helped that iwd 
uses SOCKET_OWNER by default.  What can be done is to always set 
conn_owner_nlportid and introduce another flag that would indicate 
whether 'connection tear-down on application exit' was requested.

However, my opinion is that the current SOCKET_OWNER behavior should 
just be made default, especially for control port over nl80211 
connections, even if SOCKET_OWNER was not requested.  Once the 
controlling application dies, there's no hope of salvaging the 
connection, perform rekeys, etc.

<snip>

>> 2. It has been previously suggested that CMD_FRAME infrastructure is 
>> used to
>> accomplish control port over nl80211 transport.  However, it did not 
>> seem to be
>> a good fit as the relevant code paths assume that only management 
>> frames are
>> to be sent via this mechanism.  Thoughts?
> 
> What are the issues coming from that assumption? Does it assume 802.11 
> header is present? What else?
> 

Correct.  There's also quite a bit of logic to figure out whether the 
frame is being sent offchannel or not; whether offchannel capability is 
present in the driver, etc.  This can be ignored for control port 
frames, but makes the code path complicated.

The biggest issue was that each driver defines a set of management 
frames it can accept via this mechanism.  The set is structured using 
management frame type as an identifier and the code checks this set 
prior to accepting the frame to be sent via CMD_FRAME.  Since control 
port frames are data frames it would probably require quite a bit of 
surgery in the core mac80211/wireless code and the driver code to make 
it work.

Another issue is that cfg80211_mgmt_tx_params doesn't have a 'don't 
encrypt' setting.  So that part would need to be added as well.

Regards,
-Denis
