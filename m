Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61261 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaK1OjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 09:39:03 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so18776554wiv.5
        for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2014 06:39:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417079481-22255-8-git-send-email-michal.kazior@tieto.com>
References: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
	<1417079481-22255-8-git-send-email-michal.kazior@tieto.com>
Date: Fri, 28 Nov 2014 15:39:01 +0100
Message-ID: <CA+BoTQn=g8-=FEEoW7Ux+p6s=EBy_3rwCP3qXWk_8ijR6jXY+Q@mail.gmail.com> (sfid-20141128_153907_825870_5B9F6D66)
Subject: Re: [PATCH v2 7/7] ath10k: implement wmi-tlv backend
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 November 2014 at 10:11, Michal Kazior <michal.kazior@tieto.com> wrote:
> Latest main firmware branch introduced a new WMI
> ABI called wmi-tlv. It is not a tlv strictly
> speaking but something that resembles it because
> it is ordered and may have duplicate id entries.
>
> This prepares ath10k to support new hw.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
[...]
> @@ -215,6 +254,42 @@ static inline char *wmi_service_name(int service_id)
>         SVCSTR(WMI_SERVICE_BURST);
>         SVCSTR(WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT);
>         SVCSTR(WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT);
> +       SVCSTR(WMI_SERVICE_ROAM_SCAN_OFFLOAD);
> +       SVCSTR(WMI_SERVICE_AP_PS_DETECT_OUT_OF_SYNC);
> +       SVCSTR(WMI_SERVICE_EARLY_RX);
[...]
> +       SVCSTR(WMI_SERVICE_RX_FULL_REORDER);
> +       SVCSTR(WMI_SERVICE_DHCP_OFFLOAD);

I've added 3 new service enums in v2:
WMI_SERVICE_STA_RX_IPA_OFFLOAD_SUPPORT, WMI_SERVICE_MDNS_OFFLOAD,
WMI_SERVICE_SAP_AUTH_OFFLOAD but apparently I forgot to add SVCSTR()
for that..


Michał
