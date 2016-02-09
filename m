Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36136 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbcBIVgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 16:36:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAGRGNgVuwrh5unUoQ0P+ow55ChOQ+qsRRjfD1bb7DC6PcrCO2g@mail.gmail.com>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
 <1454946096-9752-9-git-send-email-jprvita@endlessm.com> <CAGRGNgVuwrh5unUoQ0P+ow55ChOQ+qsRRjfD1bb7DC6PcrCO2g@mail.gmail.com>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Tue, 9 Feb 2016 16:35:19 -0500
Message-ID: <CA+A7VXU9zoQZ5wM2Ranf7o9vUphGb0THkh8-TUM_1yD7aC30pQ@mail.gmail.com> (sfid-20160209_223628_258529_780C72EE)
Subject: Re: [PATCH 8/9] rfkill: Userspace control for airplane mode
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 February 2016 at 17:53, Julian Calaby <julian.calaby@gmail.com> wrote:

>> +       if (ev.op == RFKILL_OP_AIRPLANE_MODE_RELEASE) {
>> +               if (rfkill_apm_owned && !data->is_apm_owner) {
>
> Are you sure this is correct?
>
> In the case that airplane mode isn't owned, the
> rfkill_apm_led_trigger_event() call will be a noop, so we should
> arguably not be calling it.
>

Ok, I'm changing the check to be consistent with _CHANGE, so the call
only succeeds if (rfkill_apm_owned && data->is_apm_owner), and return
an error otherwise.

> Also, should we just fail silently if we're not the owner? I.e. what
> does userspace learn from this op failing and is that useful?
>

I think it is better to return an error every time userspace is trying
to call an operation that it was not supposed to call at a certain
state (without acquiring control of the airplane-mode indicator). If a
program has a logic error that makes it call _RELEASE without calling
_ACQUIRE first, it's easier for the programmer to spot the problem if
we return an error here.

>> +                       count = -EACCES;
>> +               } else {
>> +                       bool state = rfkill_global_states[RFKILL_TYPE_ALL].cur;
>> +
>> +                       rfkill_apm_owned = false;
>> +                       data->is_apm_owner = false;
>> +                       rfkill_apm_led_trigger_event(state);
>> +               }
>> +       }
>> +
>> +       if (ev.op == RFKILL_OP_AIRPLANE_MODE_CHANGE) {
>> +               if (rfkill_apm_owned && data->is_apm_owner)
>> +                       rfkill_apm_led_trigger_event(ev.soft);
>> +               else
>> +                       count = -EACCES;
>> +       }
>> +
>>         if (ev.op == RFKILL_OP_CHANGE_ALL)
>>                 rfkill_update_global_state(ev.type, ev.soft);
>>
>> @@ -1230,7 +1261,17 @@ static int rfkill_fop_release(struct inode *inode, struct file *file)
>>         struct rfkill_int_event *ev, *tmp;
>>
>>         mutex_lock(&rfkill_global_mutex);
>> +
>> +       if (data->is_apm_owner) {
>> +               bool state = rfkill_global_states[RFKILL_TYPE_ALL].cur;
>> +
>> +               rfkill_apm_owned = false;
>> +               data->is_apm_owner = false;
>> +               rfkill_apm_led_trigger_event(state);
>
> Also, this code is duplicated from the _RELEASE op above. Would it
> make sense to factor it out into a separate function?
>

Yes, makes sense. This also made me notice I was assigning a negative
value to a size_t variable (count).

>> +       }
>> +
>>         list_del(&data->list);
>> +
>
> (extra line)
>

After factoring out the _RELEASE code it looks better without this
additional line.

>>         mutex_unlock(&rfkill_global_mutex);
>>
>>         mutex_destroy(&data->mtx);
>
> Thanks,
>

Thanks for the review, Julian. I'm sending an updated version.

--
João Paulo Rechi Vita
http://about.me/jprvita
