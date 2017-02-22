Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0163.hostedemail.com ([216.40.44.163]:49971 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932234AbdBVLeI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 06:34:08 -0500
Message-ID: <1487763244.14159.6.camel@perches.com> (sfid-20170222_123412_242071_B7FF845F)
Subject: Re: [PATCH] ath10k: Modify macros to fix style issues
From: Joe Perches <joe@perches.com>
To: Marcin Rokicki <marcin.rokicki@tieto.com>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 22 Feb 2017 03:34:04 -0800
In-Reply-To: <1487751327-2917-1-git-send-email-marcin.rokicki@tieto.com>
References: <1487751327-2917-1-git-send-email-marcin.rokicki@tieto.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-22 at 09:15 +0100, Marcin Rokicki wrote:
> Both macros are used internally to convert incomming parameters
> to strings in a switch case statement.
> 
> Current implementation gives following output from checkpatch.pl:
>  - ERROR: Macros with complex values should be enclosed in parentheses
>  - WARNING: Macros with flow control statements should be avoided
> 
> Fix them by modify local variable in the middle and just return at the end.
> 
> Btw add const to function that return string literals
[]
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
[]
> @@ -312,9 +312,16 @@ enum wmi_10_4_service {
>  	WMI_10_4_SERVICE_TX_MODE_DYNAMIC,
>  };
>  
> -static inline char *wmi_service_name(int service_id)
> +#define SVCSTR(x) \
> +{ \
> +	case x: \
> +		str = #x; \
> +		break; \
> +}
> +
> +static inline const char *wmi_service_name(int service_id)
>  {
> -#define SVCSTR(x) case x: return #x
> +	const char *str = NULL;
>  
>  	switch (service_id) {
>  	SVCSTR(WMI_SERVICE_BEACON_OFFLOAD);
> @@ -408,13 +415,13 @@ static inline char *wmi_service_name(int service_id)
>  	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_ONLY);
>  	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_PULL);
>  	SVCSTR(WMI_SERVICE_TX_MODE_DYNAMIC);
> -	default:
> -		return NULL;
>  	}
>  
> -#undef SVCSTR
> +	return str;
>  }
>  
> +#undef SVCSTR
> +
>  #define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id, len) \
>  	((svc_id) < (len) && \
>  	 __le32_to_cpu((wmi_svc_bmap)[(svc_id) / (sizeof(u32))]) & \
> @@ -6412,10 +6419,17 @@ enum wmi_wow_wakeup_event {
>  	WOW_EVENT_MAX,
>  };
>  
> -#define C2S(x) case x: return #x
> +#define C2S(x) \
> +{ \
> +	case x: \
> +		str = #x; \
> +		break; \
> +}
>  
>  static inline const char *wow_wakeup_event(enum wmi_wow_wakeup_event ev)
>  {
> +	const char *str = NULL;
> +
>  	switch (ev) {
>  	C2S(WOW_BMISS_EVENT);
>  	C2S(WOW_BETTER_AP_EVENT);
> @@ -6442,9 +6456,9 @@ static inline const char *wow_wakeup_event(enum wmi_wow_wakeup_event ev)
>  	C2S(WOW_BEACON_EVENT);
>  	C2S(WOW_CLIENT_KICKOUT_EVENT);
>  	C2S(WOW_EVENT_MAX);
> -	default:
> -		return NULL;
>  	}
> +
> +	return str;
>  }
>  
>  enum wmi_wow_wake_reason {
> @@ -6482,6 +6496,8 @@ enum wmi_wow_wake_reason {
>  
>  static inline const char *wow_reason(enum wmi_wow_wake_reason reason)
>  {
> +	const char *str = NULL;
> +
>  	switch (reason) {
>  	C2S(WOW_REASON_UNSPECIFIED);
>  	C2S(WOW_REASON_NLOD);
> @@ -6513,9 +6529,9 @@ static inline const char *wow_reason(enum wmi_wow_wake_reason reason)
>  	C2S(WOW_REASON_BEACON_RECV);
>  	C2S(WOW_REASON_CLIENT_KICKOUT_EVENT);
>  	C2S(WOW_REASON_DEBUG_TEST);
> -	default:
> -		return NULL;
>  	}
> +
> +	return str;
>  }
>  
>  #undef C2S

Here is an alternate style used a few times in the kernel

Maybe it'd be nicer to change the macros to something like

#define CASE_STR(x) case x: return #x

and just return NULL after the switch/case block

Maybe make that a global macro and consolidate the various
uses to a single style

drivers/net/wireless/ath/ath9k/ath9k.h:#define case_rtn_string(val) case val: return #val
drivers/net/wireless/ath/ath10k/wmi.h:#define SVCSTR(x) case x: return #x
drivers/net/wireless/ath/ath10k/wmi.h:#define C2S(x) case x: return #x
drivers/net/wireless/intel/iwlegacy/common.h:#define IL_CMD(x) case x: return #x
drivers/net/wireless/intel/iwlwifi/iwl-io.c:#define IWL_CMD(x) case x: return #x
drivers/net/wireless/intel/iwlwifi/pcie/trans.c:#define IWL_CMD(x) case x: return #x
drivers/net/wireless/atmel/at76c50x-usb.c:#define MAKE_CMD_CASE(c) case (c): return #c
drivers/net/wireless/atmel/at76c50x-usb.c:#define MAKE_CMD_STATUS_CASE(c)	case (c): return #c
drivers/net/ethernet/intel/fm10k/fm10k_pci.c:#define FM10K_ERR_MSG(type) case (type): error = #type; break
drivers/staging/lustre/lnet/selftest/selftest.h:#define STATE2STR(x) case x: return #x
include/linux/genl_magic_func.h:	case op_num: return #op_name;
t_case_default.c:#define FOO(BAR)	{ case BAR: return #BAR; }
