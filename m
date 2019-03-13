Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA0CC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 13:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41659214AE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 13:02:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrUJVJPT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfCMNCg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 09:02:36 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33146 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMNCg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 09:02:36 -0400
Received: by mail-ot1-f68.google.com with SMTP id q24so1647184otk.0
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 06:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aoUmwHM0edvHTIUNxlf5W+Wb78IypUIE3Gia/pxNG7s=;
        b=FrUJVJPTnXccgUs5OBgkVMjY8h40f3kFjWuDkLwjoZphStLKjzpntCBx3Qj2b9KQQ+
         OHWGVHkGhMuhmrAmxdE64anzhFaSd1QCtIoEZzFbka7K4aQuNLxmv6c+4BzmLYSuJA2f
         44bkaAY7cLzZpdS7Z8S1r31rqadnbTr3BruqIQaIVycxL6SlkyW03ZwQZnProQBTksPa
         5+7ib0/69e14Ys7T0iw41dke7XfRj1hq6ezo2cWLjBdGBeW6ek4VB611+HBXX5bLvT9U
         kU8lGhAn6tBlKpoYXlLGUg3tLlgbeKPsjWQ0ejU2zYom1mRR3wYXeC1xoQDUMyll/ou9
         g4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aoUmwHM0edvHTIUNxlf5W+Wb78IypUIE3Gia/pxNG7s=;
        b=BY0OUKZmnMmPFwq8RwJBOgsvhkJMnlIme02qCQ+g/gAX+X74huo5A14p9gDSGld0/r
         uZShbAmQpwjG+FOQsU3f1mlTsUffV4rILHfamuEY5esEzAsuCL+qghEwSdQ2Rq+CxdN7
         MTA6Zv07FNSVNVhIbtb5JAHkPKVUWcypnbRnvCX3v3vrZNntvcjgxZwJOEqtkv5iRiuu
         RKZeH5/PWUjxXwQpQ07wZZcWTlO4N5h9lxEH998mLERCm0M61XcvGiuJsSY2+b9KNQLH
         0WO+2DH6AuvDZcZg6zWlc1NKk3fPyrnfqaizSqeRF+eAgNDZxEwsB6d+ifiwrz9Ag3AO
         TSrw==
X-Gm-Message-State: APjAAAUWBICHyM78IXQDmt8m1kUTvSnCeh0DpphDOq9Xwx3bAFAi8Qek
        eHT0z7n+bjOeUiYk1gijS7pmLzVh4048JdjzUafFOg==
X-Google-Smtp-Source: APXvYqyl+vza0RNePvOIqZYsr2hdBPk33PYJHEOkzDlal9P5UCDBD/3PFFgTCbHsWlgz9W+ddN1pyOUW0npCcuSf1hw=
X-Received: by 2002:a9d:7d82:: with SMTP id j2mr6545375otn.270.1552482153609;
 Wed, 13 Mar 2019 06:02:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:6a97:0:0:0:0:0 with HTTP; Wed, 13 Mar 2019 06:02:32
 -0700 (PDT)
In-Reply-To: <20190313091252.GB2663@redhat.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com> <20190313091252.GB2663@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 13 Mar 2019 14:02:32 +0100
Message-ID: <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Mar 12, 2019 at 08:11:42PM +0100, Tomislav Po=C5=BEega wrote:
>> MFP can work with enabled HW crypt engine, but in this case
>> available bandwidth is reduced at least when connecting to
>> Archer C7 (QCA9558). Enable the feature for known to work chipsets-
>> MT7620, RT3070 and RT5390. Userspace setting for ieee80211w should
>> default to 0 in order to prevent unintentional bandwidth drop.
>>
>> Signed-off-by: Tomislav Po?ega <pozega.tomislav@gmail.com>
>> ---
>>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   11 +++++++----
>>  1 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> index a03b528..bb8204d 100644
>> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> @@ -9326,6 +9326,13 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev
>> *rt2x00dev)
>>  	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
>>  	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
>>
>> +	/* Experimental: Set MFP with HW crypto enabled. */
>> +	if (rt2x00_rt(rt2x00dev, RT3070) || rt2x00_rt(rt2x00dev, RT5390) ||
>> +	    rt2x00_rt(rt2x00dev, RT6352))
>> +		ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
>
> Is not that we support MFP in hardware. We just return -EOPNOTSUPP
> in rt2x00mac_set_key() when mac80211 will try to set MFP ciphers
> (since rt2x00crypto_key_to_cipher() will return CIPHER_NONE) and
> we fallback to software encryption.
>
> Please repost patch that enable MFP unconditionally with
> 'Cc: stable@vger.kernel.org' tag.
>
> Stanislaw
>

No, I have not test any other chipsets besides the ones I enabled it
for. It is possible this would cause problems on other devices, so
just enable it for the known to work ones.
