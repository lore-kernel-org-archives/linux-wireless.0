Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43031 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab1EQNCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 09:02:07 -0400
Received: by iwn34 with SMTP id 34so387259iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 06:02:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=S1X1RRaeNmqAoqugoB-dByDsaSQ@mail.gmail.com>
References: <1304413928-17673-1-git-send-email-arik@wizery.com>
 <1304527857.3563.24.camel@jlt3.sipsolutions.net> <BANLkTinB7cAmCahuK-qqejVWzO7T3Xq4Gg@mail.gmail.com>
 <BANLkTi=S1X1RRaeNmqAoqugoB-dByDsaSQ@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 17 May 2011 16:01:52 +0300
Message-ID: <BANLkTinB3fNDxQr+O4DaUpAiV4f2RXM4Tg@mail.gmail.com> (sfid-20110517_150211_787827_A37340EE)
Subject: Re: [RFC] mac80211: reestablish mis-configured existing Rx BA sessions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 5, 2011 at 02:17, Arik Nemtsov <arik@wizery.com> wrote:
> On Thu, May 5, 2011 at 02:15, Arik Nemtsov <arik@wizery.com> wrote:
>>
>>
>> On Wed, May 4, 2011 at 19:50, Johannes Berg <johannes@sipsolutions.net>
>> wrote:
>>>
>>> On Tue, 2011-05-03 at 12:12 +0300, Arik Nemtsov wrote:
>>> > When forming a Rx BA session, sometimes the ADDBA response gets lost.
>>> > This leads to a situation where the session is configured locally, but
>>> > doesn't exist on the remote side. Subsequent ADDBA requests are declined
>>> > by mac80211.
>>> >
>>> > Fix this by assuming the session state of the initiator is the correct
>>> > one. When receiving an unexpected ADDBA request on a TID with an active
>>> > Rx BA session, delete the existing one and establish a new session.
>>>
>>> I thought about this for a while but I don't really have an opinion I
>>> think. Maybe the behaviour could be avoided by checking the ack status,
>>> but that wouldn't be good enough for devices that don't have that...
>>
>> It helped me with at least two APs (when I put them far enough from the
>> station). I guess it won't hurt anything.
>> Checking the ack won't do any actual good - if the AP doesn't send another
>> ADDBA request we won't have a session up anyway. It just saves a little
>> memory on the reorder buffer.
>> Arik
>
> [replying again with a plain text email]
>

ping?
