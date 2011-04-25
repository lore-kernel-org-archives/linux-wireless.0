Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35694 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758797Ab1DYStd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 14:49:33 -0400
Received: by iwn34 with SMTP id 34so2054407iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 11:49:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <916242.83545.qm@web161604.mail.bf1.yahoo.com>
References: <916242.83545.qm@web161604.mail.bf1.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Apr 2011 11:49:13 -0700
Message-ID: <BANLkTi=pBwn2EOb+eab_3-8sEPWFh77Zsw@mail.gmail.com> (sfid-20110425_204936_654337_6985B327)
Subject: Re: [PATCH 2/2] compat-wireless: add rtl8192c/u to driver-select
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 25, 2011 at 6:30 AM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
> Add rtl8192c & rtl8192cu to rtlwifi/driver-selct
>
> Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>

Content-Transfer-Encoding: quoted-printable

Please fix your mailer.

  Luis
>
> --- a/scripts/driver-select
> +++ b/scripts/driver-select
> @@ -59,7 +59,7 @@ function usage {
>      echo -e "\t${CYAN}ath${NORMAL} < ${PURPLE} ath5k ath9k carl9170 ${NORMAL}>"
>      echo -e "\t${CYAN}iwlagn${NORMAL} < ${PURPLE} iwlagn ${NORMAL}>"
>      echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
> -    echo -e "\t${CYAN}rtlwifi${NORMAL} < ${PURPLE} rtl8192ce ${NORMAL}>"
> +    echo -e "\t${CYAN}rtlwifi${NORMAL} < ${PURPLE} rtl8192c rtl8192ce rtl8192cu ${NORMAL}>"
>      echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 wl12xx (SPI and SDIO)${NORMAL}>"
>
>      echo -e "\nSupported group drivers: Bluetooth & Ethernet:"
> @@ -327,7 +327,8 @@ case $1 in
>          disable_var_02
>          ;;
>      rtlwifi)
> -        select_drivers        CONFIG_RTL8192CE CONFIG_RTLWIFI
> +        select_drivers        CONFIG_RTL8192CE CONFIG_RTLWIFI \
> +                    CONFIG_RTL8192C CONFIG_RTL8192CU
>          disable_staging
>          disable_bt_usb_ethernet_var
>          ;;
>
>
