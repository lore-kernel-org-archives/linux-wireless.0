Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:5106 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYGWS1L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 14:27:11 -0400
Received: by nf-out-0910.google.com with SMTP id d3so932985nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 11:27:09 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: add EPO lock to rfkill-input
Date: Wed, 23 Jul 2008 20:44:24 +0200
Cc: linux-wireless@vger.kernel.org
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <1216775046-9506-5-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216775046-9506-5-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807232044.24531.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 July 2008, Henrique de Moraes Holschuh wrote:
> Add software-based sanity to rfkill-input so that it can reproduce what
> hardware-based EPO switches do, and lock down any further attempts to
> UNBLOCK radios until the switch is deactivated.
> 
> This makes rfkill and rfkill-input extend the operation of an existing
> wireless master kill switch that issues EV_SW SW_RFKILL_ALL OFF events to
> all wireless devices in the system, even those that are not under hardware
> or firmware control.
> 
> Since this is the expected operational behaviour for the master switch, the
> EPO lock functionality is not optional.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  net/rfkill/rfkill-input.c |   46 +++++++++++++-------------------------------
>  net/rfkill/rfkill-input.h |    1 +
>  net/rfkill/rfkill.c       |   36 ++++++++++++++++++++++++++++++++--
>  3 files changed, 48 insertions(+), 35 deletions(-)
> 
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index 273fb38..8e6781d 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -47,6 +47,8 @@ struct rfkill_task {
>  enum rfkill_global_sched_op {
>  	RFKILL_GLOBAL_OP_EPO = 0,
>  	RFKILL_GLOBAL_OP_RESTORE,
> +	RFKILL_GLOBAL_OP_UNLOCK,
> +	RFKILL_GLOBAL_OP_UNBLOCK,
>  };

As mentioned in the previous patch "rfkill: add master_switch_mode functionality"
the above 2 new enums aren't allowed because they are blocked in the module
init function.

>  static void rfkill_schedule_toggle(struct rfkill_task *task)
>  {
>  	unsigned long flags;
> @@ -169,30 +161,19 @@ static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
>  static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
>  static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
>  static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
> -static DEFINE_RFKILL_TASK(rfkill_wwan, RFKILL_TYPE_WWAN);

Are all RFKILL_TYPE_WWAN users gone?
In that case the define should disappear completely.

Ivo
