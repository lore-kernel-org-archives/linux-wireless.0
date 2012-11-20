Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58786 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2KTKZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 05:25:40 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so4105784iay.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 02:25:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEdVi2FADa-4YOtBfexMU+G8YG8LOnL22FuUji_P18ggfQ@mail.gmail.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
 <1353343170-26516-11-git-send-email-eliad@wizery.com> <CA+XVXfet9PT9j2TCWsK2O-P3CTn+-6kO-U+OJ=ajvRJim+8LeQ@mail.gmail.com>
 <CAB3XZEdVi2FADa-4YOtBfexMU+G8YG8LOnL22FuUji_P18ggfQ@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 20 Nov 2012 12:25:24 +0200
Message-ID: <CA+XVXfeMiWnUVwLYdhBsCtZ=ZRh9vo2W==y-_wY-upCywJeYBw@mail.gmail.com> (sfid-20121120_112544_045716_AEC3EA3A)
Subject: Re: [PATCH 10/15] wlcore: initiate ROC/CROC on sta state updates
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 10:42 AM, Eliad Peller <eliad@wizery.com> wrote:
> On Mon, Nov 19, 2012 at 11:41 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> On Mon, Nov 19, 2012 at 6:39 PM, Eliad Peller <eliad@wizery.com> wrote:
>>> Use the sta_state notifications to ROC when a station
>>> is about to connect, and CROC respectively on
>>> authorization (success) / deletion (failure).
>>>
>>> Change the wl12xx_update_sta_state() flow to bail out
>>> only on error, so multiple code blocks could refer
>>> to the same state.
>>>
>>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> [...]
>>>
>>> +       /* clear ROCs on failure or authorization */
>>> +       if (is_sta &&
>>> +           (new_state == IEEE80211_STA_AUTHORIZED ||
>>> +            new_state == IEEE80211_STA_NOTEXIST)) {
>>> +               if (test_bit(wlvif->role_id, wl->roc_map))
>>> +                       wl12xx_croc(wl, wlvif->role_id);
>>> +       }
>>> +
>>> +       if (is_sta &&
>>> +           old_state == IEEE80211_STA_NOTEXIST &&
>>> +           new_state == IEEE80211_STA_NONE) {
>>> +               if (find_first_bit(wl->roc_map,
>>> +                                  WL12XX_MAX_ROLES) >= WL12XX_MAX_ROLES) {
>>> +                       WARN_ON(wlvif->role_id == WL12XX_INVALID_ROLE_ID);
>>> +                       wl12xx_roc(wl, wlvif, wlvif->role_id, wlvif->channel);
>>> +               }
>>> +       }
>>
>> what about AP mode? we don't have an opportunistic ROC there as well
>> for connecting stations?
>
> yeah, we do. but since in order to really be effective it requires
> supplicant changes that weren't upstreamed yet (adding non-associated
> station), i preferred postponing it to another patchset.
> on the other hand, this might help protecting the EAPOL exchange even
> in its current form, so i guess we can upstream it even before the
> supplicant changes.

yea. since this is opportunistic, it can't really hurt.
