Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43989 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbcBOJYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 04:24:08 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Eliad Peller <eliad@wizery.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Peller, EliadX" <eliadx.peller@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: mvm: move TX PN assignment for TKIP to the
 driver
Date: Mon, 15 Feb 2016 09:24:04 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA1338D@hasmsx107.ger.corp.intel.com> (sfid-20160215_102413_731488_E630303E)
References: <1455450997-15409-1-git-send-email-emmanuel.grumbach@intel.com>
 <1455450997-15409-2-git-send-email-emmanuel.grumbach@intel.com>
 <CANUX_P3Ybzowsf3Kg7TFhtpq+H4bDWMswrGHhkrvHKtnZaEVhA@mail.gmail.com>
 <1455477875.2564.0.camel@sipsolutions.net>
 <0BA3FCBA62E2DC44AF3030971E174FB32EA122F3@hasmsx107.ger.corp.intel.com>
 <CAB3XZEdXC1jG5FXOPu-seT2pVzKa6Sg15s_YTeMnULi7vBgL5A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32EA1331F@hasmsx107.ger.corp.intel.com>
 <CAB3XZEeYfYaHUOcBjxpD5+_4YGRemm6W+YDRksPjxBqCxvTPtw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/15/2016 11:21 AM, Eliad Peller wrote:
> On Mon, Feb 15, 2016 at 11:16 AM, Grumbach, Emmanuel
> <emmanuel.grumbach@intel.com> wrote:
>>
>> On 02/15/2016 11:06 AM, Eliad Peller wrote:
>>> On Sun, Feb 14, 2016 at 9:37 PM, Grumbach, Emmanuel
>>> <emmanuel.grumbach@intel.com> wrote:
>>>> On 02/14/2016 09:33 PM, Johannes Berg wrote:
>>>>> On Sun, 2016-02-14 at 19:34 +0200, Emmanuel Grumbach wrote:
>>>>>> Since the 3rd patch needs to be dropped anyway, let's route this one
>>>>>> through my tree as usual.
>>>>> It doesn't really have to be dropped, why? We can just make the same
>>>>> adjustment as for dvm in the patch.
>>>>>
>>>> But I am not sure I really want to play with drivers/staging/vt6656/rxtx.c
>>> here you go:
>>>
>>> diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
>>> index b668db6..1a2dda0 100644
>>> --- a/drivers/staging/vt6655/rxtx.c
>>> +++ b/drivers/staging/vt6655/rxtx.c
>>>
>> Want to send that patch to Greg? :)
> why? can't you simply amend it to the third patch?
>
>

It doesn't feel right to remove this function in mac80211-next.git and
touch 3 drivers along the way, but I don't mind. Johannes, what do you say?
