Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:62130 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYHBSC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 14:02:29 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1723588ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 11:02:28 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/2] rfkill: protect suspended rfkill controllers
Date: Sat, 2 Aug 2008 20:25:11 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1217699786-20672-1-git-send-email-hmh@hmh.eng.br> <1217699786-20672-2-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1217699786-20672-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808022025.12160.IvDoorn@gmail.com> (sfid-20080802_200232_974008_43E87E40)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 August 2008, Henrique de Moraes Holschuh wrote:
> Guard rfkill controllers attached to a rfkill class against state changes
> after class suspend has been issued.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  Documentation/rfkill.txt |    5 +++++
>  net/rfkill/rfkill.c      |   14 ++++++++++----
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
> index 28b6ec8..6fcb306 100644
> --- a/Documentation/rfkill.txt
> +++ b/Documentation/rfkill.txt
> @@ -363,6 +363,11 @@ This rule exists because users of the rfkill subsystem expect to get (and set,
>  when possible) the overall transmitter rfkill state, not of a particular rfkill
>  line.
>  
> +5. During suspend, the rfkill class will attempt to soft-block the radio
> +through a call to rfkill->toggle_radio, and will try to restore its previous
> +state during resume.  After a rfkill class is suspended, it will *not* call
> +rfkill->toggle_radio until it is resumed.
> +
>  Example of a WLAN wireless driver connected to the rfkill subsystem:
>  --------------------------------------------------------------------
>  
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index d2d4565..35a9994 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -150,6 +150,8 @@ static void update_rfkill_state(struct rfkill *rfkill)
>   * calls and handling all the red tape such as issuing notifications
>   * if the call is successful.
>   *
> + * Suspended devices are not touched at all, and -EAGAIN is returned.
> + *
>   * Note that the @force parameter cannot override a (possibly cached)
>   * state of RFKILL_STATE_HARD_BLOCKED.  Any device making use of
>   * RFKILL_STATE_HARD_BLOCKED implements either get_state() or
> @@ -168,6 +170,9 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>  	int retval = 0;
>  	enum rfkill_state oldstate, newstate;
>  
> +	if (unlikely(rfkill->dev.power.power_state.event & PM_EVENT_SLEEP))
> +		return -EBUSY;
> +
>  	oldstate = rfkill->state;
>  
>  	if (rfkill->get_state && !force &&
> @@ -214,7 +219,7 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>   *
>   * This function toggles the state of all switches of given type,
>   * unless a specific switch is claimed by userspace (in which case,
> - * that switch is left alone).
> + * that switch is left alone) or suspended.
>   */
>  void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
>  {
> @@ -239,8 +244,8 @@ EXPORT_SYMBOL(rfkill_switch_all);
>  /**
>   * rfkill_epo - emergency power off all transmitters
>   *
> - * This kicks all rfkill devices to RFKILL_STATE_SOFT_BLOCKED, ignoring
> - * everything in its path but rfkill_mutex and rfkill->mutex.
> + * This kicks all non-suspended rfkill devices to RFKILL_STATE_SOFT_BLOCKED,
> + * ignoring everything in its path but rfkill_mutex and rfkill->mutex.
>   */
>  void rfkill_epo(void)
>  {
> @@ -458,13 +463,14 @@ static int rfkill_resume(struct device *dev)
>  	if (dev->power.power_state.event != PM_EVENT_ON) {
>  		mutex_lock(&rfkill->mutex);
>  
> +		dev->power.power_state.event = PM_EVENT_ON;
> +
>  		/* restore radio state AND notify everybody */
>  		rfkill_toggle_radio(rfkill, rfkill->state, 1);
>  
>  		mutex_unlock(&rfkill->mutex);
>  	}
>  
> -	dev->power.power_state = PMSG_ON;
>  	return 0;
>  }
>  #else


