Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:58974 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbZA2PRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 10:17:05 -0500
Received: by wf-out-1314.google.com with SMTP id 27so8731652wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2009 07:17:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233231739-4402-1-git-send-email-vasanth@atheros.com>
References: <1233231739-4402-1-git-send-email-vasanth@atheros.com>
Date: Thu, 29 Jan 2009 10:17:04 -0500
Message-ID: <b6c5339f0901290717m760c4704x7f9df7502f772a17@mail.gmail.com> (sfid-20090129_161712_787053_46F15C75)
Subject: Re: [PATCH] ath9k: Fix LED blink pattern
From: Bob Copeland <bcopeland@gmail.com>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com, Jouni.Malinen@atheros.com,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 29, 2009 at 7:22 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath9k/core.h |   10 +++++++
>  drivers/net/wireless/ath9k/main.c |   52 ++++++++++++++++++++++++++++++++----
>  2 files changed, 56 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
> index 29251f8..9a7bb1b 100644
> --- a/drivers/net/wireless/ath9k/core.h
> +++ b/drivers/net/wireless/ath9k/core.h
> @@ -600,6 +600,8 @@ struct ath_ani {
>  /********************/
>
>  #define ATH_LED_PIN    1
> +#define ATH_LED_ON_DURATION_IDLE       350     /* in msecs */
> +#define ATH_LED_OFF_DURATION_IDLE      250     /* in msecs */
>
>  enum ath_led_type {
>        ATH_LED_RADIO,
> @@ -677,6 +679,7 @@ enum PROT_MODE {
>  #define SC_OP_RFKILL_SW_BLOCKED        BIT(12)
>  #define SC_OP_RFKILL_HW_BLOCKED        BIT(13)
>  #define SC_OP_WAIT_FOR_BEACON  BIT(14)
> +#define SC_OP_LED_ON           BIT(15)
>
>  struct ath_bus_ops {
>        void            (*read_cachesize)(struct ath_softc *sc, int *csz);
> @@ -725,10 +728,17 @@ struct ath_softc {
>        struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
>        struct ath_rate_table *cur_rate_table;
>        struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
> +
>        struct ath_led radio_led;
>        struct ath_led assoc_led;
>        struct ath_led tx_led;
>        struct ath_led rx_led;
> +       struct delayed_work ath_led_blink_work;
> +       int led_on_duration;
> +       int led_off_duration;
> +       int led_on_cnt;
> +       int led_off_cnt;

This is something that has come up from time to time from users for
ath5k as well.  Half of the drivers now have their own timers for
turning leds on or off.

Can we just add a decent blink algorithm to mac80211?  Right now for
rx it just toggles every other packet.  For tx, it's slightly smarter
but not overly so.  It seems like this is one of those things everyone
wants to do and we could easily make it a standard service.

-- 
Bob Copeland %% www.bobcopeland.com
