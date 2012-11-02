Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53798 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2KBUd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2012 16:33:56 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so4139708vcb.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2012 13:33:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+7oygdwK=8i_oWgoeXKRgxJAzOyyXjkmuGpO+mBsAdcRRqzGg@mail.gmail.com>
References: <CA+7oygeOHQLcdEWpedbXDnBoAHrXddkrmNd3-PNQOKzoyNkn6w@mail.gmail.com>
	<CA+7oygfnsrqAyU4d3n7EgmOntenhp36DEGhSnJ4FsJFdOKCk-w@mail.gmail.com>
	<CA+7oygdwK=8i_oWgoeXKRgxJAzOyyXjkmuGpO+mBsAdcRRqzGg@mail.gmail.com>
Date: Fri, 2 Nov 2012 16:33:56 -0400
Message-ID: <CA+7oygd9aCHHWaUy56QkRfnVpnOzcw26E6NA=L8T1bB71K9Fug@mail.gmail.com> (sfid-20121102_213408_935446_81997245)
Subject: Re: bug in compat-wireless 3.6, rt2x00 iftype is wrong
From: George Nychis <gnychis@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d043893b303e6c504cd890e24
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d043893b303e6c504cd890e24
Content-Type: text/plain; charset=ISO-8859-1

This fixes my issue, but I don't know if it's the ideal patch.

On Fri, Nov 2, 2012 at 3:59 PM, George Nychis <gnychis@gmail.com> wrote:
> in the compat-wireless-3.6.-rc7-1 source code, I'm talking about line
> 88 in net/wireless/chan.c which returns -EBUSY.  Note that I have a
> single interface which is in station mode, not monitoring mode.  There
> is no interface in true monitoring mode.
>
> On Fri, Nov 2, 2012 at 3:57 PM, George Nychis <gnychis@gmail.com> wrote:
>> The issue seems to be that in all of these drivers, wdev is NULL when
>> you hit set_channel()  in the older and newer driver.  In the old
>> driver, cfg8011_set_freq() is called with wdev has NULL and it still
>> calls rdev->ops->set_channel(....) which succeeds.
>>
>> However, in the new driver cfg80211_set_monitor_channel() is called
>> since wdev was NULL, but now instead of still calling
>> rdev->ops->set_channel() or rdev->ops->set_monitor_channel() it
>> returns -EBUSY because if(!cfg80211_has_monitors_only(rdev)) returns
>> true.  Is this really the expected behavior, or is meant to only
>> return -EBUSY if there are only monitors, rather? (i.e.,
>> if(cfg80211_has_monitors_only(rdev)) )
>>
>>
>> On Fri, Nov 2, 2012 at 2:46 PM, George Nychis <gnychis@gmail.com> wrote:
>>> I'm still trying to track down the cause for this, but starting in
>>> compat-wireless-3.6 (including early RCs and the most recent 3.6.2),
>>> rt2x00 devices register with the wrong iftype.  They register as
>>> NL80211_IFTYPE_MONITOR instead of NL80211_IFTYPE_STATION, for example.
>>>  I checked cw-3.5, 3.4, 3.2, and 3.1 and none of these versions have
>>> this bug.
>>>
>>> This breaks the ability to set channels, etc.  Hoping to track down
>>> the bug, but wanted to report it in the meantime and see if anyone
>>> else has run in to it.
>>>
>>> - George

--f46d043893b303e6c504cd890e24
Content-Type: application/octet-stream; name="rt2x00_setchan_fix.patch"
Content-Disposition: attachment; filename="rt2x00_setchan_fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h91rgo9j0

ZGlmZiAtLWdpdCBhL2NvbXBhdC13aXJlbGVzcy0zLjYtcmM3LTEvbmV0L3dpcmVsZXNzL2NoYW4u
YyBiL2NvbXBhdC13aXJlbGVzcy0zLjYtcmM3LTEvbmV0L3dpcmVsZXNzL2NoYW4uYwppbmRleCBk
MzU1ZjY3Li5lMDg1YTEwIDEwMDY0NAotLS0gYS9jb21wYXQtd2lyZWxlc3MtMy42LXJjNy0xL25l
dC93aXJlbGVzcy9jaGFuLmMKKysrIGIvY29tcGF0LXdpcmVsZXNzLTMuNi1yYzctMS9uZXQvd2ly
ZWxlc3MvY2hhbi5jCkBAIC04NSw3ICs4NSw3IEBAIGludCBjZmc4MDIxMV9zZXRfbW9uaXRvcl9j
aGFubmVsKHN0cnVjdCBjZmc4MDIxMV9yZWdpc3RlcmVkX2RldmljZSAqcmRldiwKIAogCWlmICgh
cmRldi0+b3BzLT5zZXRfbW9uaXRvcl9jaGFubmVsKQogCQlyZXR1cm4gLUVPUE5PVFNVUFA7Ci0J
aWYgKCFjZmc4MDIxMV9oYXNfbW9uaXRvcnNfb25seShyZGV2KSkKKwlpZiAoY2ZnODAyMTFfaGFz
X21vbml0b3JzX29ubHkocmRldikpCiAJCXJldHVybiAtRUJVU1k7CiAKIAljaGFuID0gcmRldl9m
cmVxX3RvX2NoYW4ocmRldiwgZnJlcSwgY2hhbnR5cGUpOwo=
--f46d043893b303e6c504cd890e24--
