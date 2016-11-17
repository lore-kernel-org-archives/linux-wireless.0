Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.smtp.broadcom.com ([192.19.211.62]:38285 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753307AbcKQLkB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 06:40:01 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC 0/5] nl80211: add support for g-scan
Date: Thu, 17 Nov 2016 11:39:47 +0000
Message-Id: <1479382792-13131-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161117_124011_462058_BAE7DA40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Android employs a Wifi-HAL layer in its wireless frame. It basically abstracts
dealing with netlink messages from the framework. For some features it employs
nl80211 vendor commands. The goal I set myself is to be able to have a generic
nl80211 Wifi-HAL implementation. One of the features currently requiring the
vendor commands is g-scan. We can only guess what the 'g' stands for ;-) This
series converts the vendor command api into common nl80211 api.

Before making an attempt to explain more about the g-scan functionality first
this. While I am still testing the driver implementation resulting in numerous
questions Dmitry send the email below to bring a related discussion to the
table..eh.. the linux-wireless list. This is probably a good thing as anyone
can dive in and share their thoughts.

On 16-11-2016 23:47, dimitrysh@google.com wrote:
> From 68a9d37a4c7e9dc7a90a6e922cdea52737a98d66 Mon Sep 17 00:00:00 2001
> From: Dmitry Shmidt <dimitrysh@google.com>
> Date: Wed, 16 Nov 2016 14:27:26 -0800
> Subject: [PATCH] RFC: Universal scan proposal
>
>   Currently we have sched scan with possibility of various
> intervals. We would like to extend it to support also
> different types of scan.

Extending would be an option, but replacing sched_scan by uscan does not
seem like a good idea although you are only redefining the driver api, but
it seems elaborate to map all user-space scans to the new uscan callback.

>   In case of powerful wlan CPU, all this functionality
> can be offloaded.
>   In general case FW processes additional scan requests
> and puts them into queue based on start time and interval.
> Once current request is fulfilled, FW adds it (if interval != 0)
> again to the queue with proper interval. If requests are
> overlapping, new request can be combined with either one before,
> or one after, assuming that requests are not mutually exclusive.
>   Combining requests is done by combining scan channels, ssids,
> bssids and types of scan result. Once combined request was fulfilled
> it will be reinserted as two (or three) different requests based on
> their type and interval.
>   Each request has attribute:
> Type: connectivity / location
> Report: none / batch / immediate

These probably need more explanation. The 'Type' attribute gives hint about
the high-level use-case, ie. (android) connectivity or location service. This
obviously should have a different behaviour in the driver/device so we need to
describe that behaviour.

>   Request may have priority and can be inserted into
> the head of the queue.
>   Types of scans:
> - Normal scan
> - Scheduled scan
> - Hotlist (BSSID scan)
> - Roaming
> - AutoJoin

Are these last two really scans? How should AutoJoin work dealing with the
connection state of wpa_supplicant and driver/device if establishing the
connection is entirely offloaded including eapol handshakes and key derivation.

Now getting back to this series, it adds basic support of g-scan (or GScan, or
gscan, or something completely different; suggestions are welcome). A basic
g-scan request consists of some common attributes and so-called buckets. Each
bucket represents a re-occurring scan request with a given interval and a set
of channels. The common attributes specify how much scans (m) should be stored
and how many BSS-es (n) should be kept per scan before an event is sent. The
other option is to specify a percentage at which an event is sent, where 100%
equals (m * n). It also specifies the base period, but we may drop that as it
is the gcd() of the individual buckets. A special case of bucket is the
exponential backoff bucket, which has a increasing interval.

Whether this type of scan offload is a good addition depends on the high-level
use-case(s). It would help this discussion greatly to know those use-case(s).
A current hurdle for me is that the device stores m scans so a BSS could end up
in the result of either of them. However, cfg80211 stores BSS-es uniquely with
latest scan information. Does user-space need results per scan or is flat BSS
storage fine.

Anyway, here is some more fuel to the discussion.

Regards,
Arend

Arend van Spriel (5):
  nl80211: allow reporting RTT information in scan results
  nl80211: add reporting of gscan capabilities
  nl80211: add support for gscan
  nl80211: rename some notification functions
  nl80211: add driver api for gscan notifications

 include/net/cfg80211.h       | 166 +++++++++++++++-
 include/uapi/linux/nl80211.h | 212 +++++++++++++++++++++
 net/wireless/core.c          |  33 ++++
 net/wireless/core.h          |   6 +
 net/wireless/nl80211.c       | 440 +++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.h       |   4 +-
 net/wireless/rdev-ops.h      |  25 +++
 net/wireless/scan.c          |  95 +++++++++-
 net/wireless/trace.h         |  19 ++
 9 files changed, 984 insertions(+), 16 deletions(-)

--
1.9.1
