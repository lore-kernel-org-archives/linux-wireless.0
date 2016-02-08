Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:36569 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752820AbcBHWx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 17:53:27 -0500
MIME-Version: 1.0
In-Reply-To: <1454946096-9752-9-git-send-email-jprvita@endlessm.com>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com> <1454946096-9752-9-git-send-email-jprvita@endlessm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 9 Feb 2016 09:53:06 +1100
Message-ID: <CAGRGNgVuwrh5unUoQ0P+ow55ChOQ+qsRRjfD1bb7DC6PcrCO2g@mail.gmail.com> (sfid-20160208_235332_560880_2DAE93A0)
Subject: Re: [PATCH 8/9] rfkill: Userspace control for airplane mode
To: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
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

Hi João,

On Tue, Feb 9, 2016 at 2:41 AM, João Paulo Rechi Vita <jprvita@gmail.com> wrote:
> Provide an interface for the airplane-mode indicator be controlled from
> userspace. User has to first acquire the control through
> RFKILL_OP_AIRPLANE_MODE_ACQUIRE and keep the fd open for the whole time
> it wants to be in control of the indicator. Closing the fd or using
> RFKILL_OP_AIRPLANE_MODE_RELEASE restores the default policy.
>
> To change state of the indicator, the RFKILL_OP_AIRPLANE_MODE_CHANGE
> operation is used, passing the value on "struct rfkill_event.soft". If
> the caller has not acquired the airplane-mode control beforehand, the
> operation fails.
>
> Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
> ---
>  Documentation/rfkill.txt    | 10 ++++++++++
>  include/uapi/linux/rfkill.h |  3 +++
>  net/rfkill/core.c           | 47 ++++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 57 insertions(+), 3 deletions(-)
>
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index fb11547..8067701 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -1207,6 +1210,34 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
>
>         mutex_lock(&rfkill_global_mutex);
>
> +       if (ev.op == RFKILL_OP_AIRPLANE_MODE_ACQUIRE) {
> +               if (rfkill_apm_owned && !data->is_apm_owner) {
> +                       count = -EACCES;
> +               } else {
> +                       rfkill_apm_owned = true;
> +                       data->is_apm_owner = true;
> +               }
> +       }
> +
> +       if (ev.op == RFKILL_OP_AIRPLANE_MODE_RELEASE) {
> +               if (rfkill_apm_owned && !data->is_apm_owner) {

Are you sure this is correct?

In the case that airplane mode isn't owned, the
rfkill_apm_led_trigger_event() call will be a noop, so we should
arguably not be calling it.

Also, should we just fail silently if we're not the owner? I.e. what
does userspace learn from this op failing and is that useful?

> +                       count = -EACCES;
> +               } else {
> +                       bool state = rfkill_global_states[RFKILL_TYPE_ALL].cur;
> +
> +                       rfkill_apm_owned = false;
> +                       data->is_apm_owner = false;
> +                       rfkill_apm_led_trigger_event(state);
> +               }
> +       }
> +
> +       if (ev.op == RFKILL_OP_AIRPLANE_MODE_CHANGE) {
> +               if (rfkill_apm_owned && data->is_apm_owner)
> +                       rfkill_apm_led_trigger_event(ev.soft);
> +               else
> +                       count = -EACCES;
> +       }
> +
>         if (ev.op == RFKILL_OP_CHANGE_ALL)
>                 rfkill_update_global_state(ev.type, ev.soft);
>
> @@ -1230,7 +1261,17 @@ static int rfkill_fop_release(struct inode *inode, struct file *file)
>         struct rfkill_int_event *ev, *tmp;
>
>         mutex_lock(&rfkill_global_mutex);
> +
> +       if (data->is_apm_owner) {
> +               bool state = rfkill_global_states[RFKILL_TYPE_ALL].cur;
> +
> +               rfkill_apm_owned = false;
> +               data->is_apm_owner = false;
> +               rfkill_apm_led_trigger_event(state);

Also, this code is duplicated from the _RELEASE op above. Would it
make sense to factor it out into a separate function?

> +       }
> +
>         list_del(&data->list);
> +

(extra line)

>         mutex_unlock(&rfkill_global_mutex);
>
>         mutex_destroy(&data->mtx);

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
