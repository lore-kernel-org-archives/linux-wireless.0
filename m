Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:39479 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaBSR42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 12:56:28 -0500
Received: by mail-lb0-f177.google.com with SMTP id 10so538405lbg.8
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 09:56:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5304EBB1.904@broadcom.com>
References: <1392824377-18254-1-git-send-email-ilan.peer@intel.com>
 <1392824377-18254-2-git-send-email-ilan.peer@intel.com> <20140219161101.GJ14296@garbanzo.do-not-panic.com>
 <5304EBB1.904@broadcom.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 19 Feb 2014 09:56:06 -0800
Message-ID: <CAB=NE6WSag35Y+CrAHu1QTj27f3W1JavsPeiEXwEcLUL8Zj4XQ@mail.gmail.com> (sfid-20140219_185631_644631_0A8C3213)
Subject: Re: [PATCH v4 1/5] cfg80211: Add indoor only and GO concurrent
 channel attributes
To: Arend van Spriel <arend@broadcom.com>
Cc: Ilan Peer <ilan.peer@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Spinadel <david.spinadel@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 9:36 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 02/19/2014 05:11 PM, Luis R. Rodriguez wrote:
>> On Wed, Feb 19, 2014 at 05:39:33PM +0200, Ilan Peer wrote:
>>> From: David Spinadel <david.spinadel@intel.com>
>>>
>>> The FCC are clarifying some soft configuration requirements,
>>> which among other include the following:
>>>
>>> 1. Indoor operation, where a device can use channels requiring indoor
>>>    operation, subject to that it can guarantee indoor operation,
>>>    i.e., the device is connected to AC Power or the device is under
>>>    the control of a local master that is acting as an AP and is
>>>    connected to AC Power.
>>> 2. Concurrent GO operation, where devices may instantiate a P2P GO
>>>    while they are under the guidance of an authorized master. For example,
>>>    on a channel on which a BSS is connected to an authorized master, i.e.,
>>>    with DFS and radar detection capability in the UNII band.
>
> So apparently FCC has another understanding than the WiFi Alliance (from
> section 2.3 in WFA P2P-TS):
>
> """
> A P2P Device can operate concurrently with a WLAN (infrastructure
> network). Such a device is considered a P2P Concurrent Device. The
> concurrent operation requires a device to support multiple MAC entities.
>         :
>         :
> A P2P Group may operate in the same or different operating class and
> channel as a concurrently operating WLAN BSS. For example, a WLAN BSS
> may operate in channel 36 in the 5.2 GHz band, while the P2P Group may
> operate in channel 6 in the 2.4 GHz band.
> """

But can a WLAN BSS operate on channel 6 in the 2.4 GHz band and infer
it can start GO on channel 36? This question seems not related to
concurrent stuff but rather pure regulatory but I suppose that will
depend on the definition that the FCC intended behind GO concurrency.
Is the definition of concurrency GO thing supposed to *restrict* the
number of interfaces a device can create (STA, GO), or simply define
permissive rules which would have otherwise been blocked?

  Luis
