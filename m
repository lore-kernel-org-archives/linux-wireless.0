Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CF9C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 08:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B323C20830
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 08:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RK+S8uAu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbfCZINO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 04:13:14 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33446 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfCZINN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 04:13:13 -0400
Received: by mail-ot1-f68.google.com with SMTP id j10so4171886otq.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2019 01:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=3iQY2044ltiP2GVGOJEJDrmIhYEt4TQSZ46wgSgf+uU=;
        b=RK+S8uAutXG0XRuCyIpbr5gFTtAdI3N3n+10sTN0rVbzdjNzLb4odBa/wltMTrBbnm
         T9+CeeIJEj6/C2IrW/Avl7bcv3WpYs+yUWvtXlqawQ+wWwXFDnUQNzDZLDBkN8LfzZPB
         W17XN/qYEWNYG9ZOliK3R/7ewejDgtMwvovKmHBHQXK79VHqR2aioNcwktCms8Q3vGxu
         wCBkJ1gNh/1Lzy7+MEz48hNXN62CTzD8hfHNbkRhw+2wTxuHJ0qW0oBQ9rP4xJ/Yh+2o
         BFwNtHm3jzZl+uk/cvT3oqawdfDleU2h6lNKbiRCJogiaQiq5YCOhivnH7FMH/By2ID9
         D6Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=3iQY2044ltiP2GVGOJEJDrmIhYEt4TQSZ46wgSgf+uU=;
        b=et3a0qVXf+Gj4HcFR2UBkc8TVRyL+xyLaasb52U0xZHPOsOGUXNYFlPbuXZGlFDlsF
         EggvUsTX6eNrUpw7gxPA8vrAKicvLdTnvcxytAbpE1LLK1pOAaArg59vPmh4o/dANIEw
         N8w6CE3jjsKcWM7ojVTGI6/JdT8j3cacdyy5ZInJN/SzcnX1NN6Oq/+vUe3JpIbNMFVL
         wdScSx6+XpeS+WizpwVyqG4J7uCQILoKTHIkk4JSz8sNu+Np36pWihTx3lSicCFJT5o3
         salUSRQkrd9tpAHVCctRbOL6iyIk9HZvIULbvi2hhDQar3yf0TfQTw+hP8cCGIqRnpTM
         8/jw==
X-Gm-Message-State: APjAAAVq7yGkgyN7WZ/MJRrpVzxZWkpCd2D1LliXdig+EZgIunmOvk3I
        35XjIXqEmPRyOlkz/+x6u9ZPPF0HlJFQXUVfBR0=
X-Google-Smtp-Source: APXvYqxZ/imR1UJGirwDiQV0tn/gIy5KOvufMLP6wyHlq6RzGTa3NisGrXHLmcJeV0oUQoDNT7j8e20cgQbWVskMfwE=
X-Received: by 2002:a9d:7acc:: with SMTP id m12mr1196743otn.296.1553587992687;
 Tue, 26 Mar 2019 01:13:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Tue, 26 Mar 2019 01:13:11
 -0700 (PDT)
In-Reply-To: <20190326061618.GA7200@redhat.com>
References: <20190313091252.GB2663@redhat.com> <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com> <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
 <20190313140607.GE2003@redhat.com> <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
 <20190313155028.GB5302@redhat.com> <CAKR_QV+=i_Sp26zCkTC9cAHrhVLq4w0FoxLVmD-T3wFyd-ruEQ@mail.gmail.com>
 <20190325142537.GA13884@redhat.com> <CAKR_QV+zUBKk=8UHiCnWQg9XCdB8zbMEcVSKEO7vFOR0Q2Yesw@mail.gmail.com>
 <20190326061618.GA7200@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 26 Mar 2019 09:13:11 +0100
Message-ID: <CAKR_QVK-+w1p3kwstJG=k0w1dp42knGGUe5VrFKq-45yYhkuHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 26/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Mar 26, 2019 at 02:54:25AM +0100, Tom Psyborg wrote:
>> On 25/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > On Thu, Mar 14, 2019 at 03:02:14PM +0100, Tom Psyborg wrote:
>> >> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> >>
>> >> >
>> >> > There should be no difference between enabling MFP with nohwcrypt
>> >> > and
>> >> > without nohwcrypt,
>> >>
>> >> well there is. do you still want me to resend this with MFP enabled
>> >> unconditionally for all chips?
>> >
>> > Please share your hostapd config file with MFP enabled.
>> >
>> > Stanislaw
>> >
>> >
>>
>> ctrl_interface=/var/run/wpa_supplicant
>> eapol_version=1
>> ap_scan=1
>> fast_reauth=1
>> pmf=2
>> network={
>> 	ssid="OpenWrt"
>> 	proto=WPA2
>> 	key_mgmt=WPA-PSK
>> 	pairwise=CCMP
>> 	group=CCMP
>> 	ieee80211w=2
>> 	psk="u7e5hwh46uz7ergv"
>> 	wpa_ptk_rekey=60
>> }
>
> This is supplicant config, I asked for hostapd. You can find it in
> /tmp/run/hostapd-phy0.conf (I assume you use openwrt on QCA router,
> or you use proprietary firmware ?).
>
> Stanislaw
>

in case it really matters here it is. basically default settings:

driver=nl80211
logger_syslog=127
logger_syslog_level=2
logger_stdout=127
logger_stdout_level=2
country_code=US
ieee80211d=1
hw_mode=g
supported_rates=60 90 120 180 240 360 480 540
basic_rates=60 120 240
beacon_int=100
channel=5

noscan=1
ieee80211n=1
ht_coex=0
ht_capab=[HT40+][LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][DSSS_CCK-40]

interface=wlan0
ctrl_interface=/var/run/hostapd
ap_isolate=1
bss_load_update_period=60
chan_util_avg_period=600
disassoc_low_ack=1
preamble=1
wmm_enabled=1
ignore_broadcast_ssid=0
uapsd_advertisement_enabled=1
wpa_passphrase=u7e5hwh46uz7ergv
auth_algs=1
wpa=2
wpa_pairwise=CCMP
ssid=OpenWrt
bridge=br-lan
wpa_disable_eapol_key_retries=1
wpa_key_mgmt=WPA-PSK WPA-PSK-SHA256
okc=0
disable_pmksa_caching=1
ieee80211w=2
group_mgmt_cipher=AES-128-CMAC
bssid=10:fe:ed:a7:11:5f
