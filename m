Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48877C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 14:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EACD22087C
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 14:41:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GsOHq58w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfCMOlx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:41:53 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45887 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMOlx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 10:41:53 -0400
Received: by mail-oi1-f194.google.com with SMTP id t82so1593389oie.12
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 07:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YKLdTIejgEKY8NvlEMEihS6IUYygfbj/x16/G0vBSQc=;
        b=GsOHq58wr+OKQngb9jw0PfJNgIFW5QXk2tD27lJ5I3xq0YlhZhpj07Z7DDzCKIpcK4
         Qe7yJyj83IJvAAz+3D+ax/jbnu/lieLOPOszSjj6wZKg+kTpcSPPMcW1ESYkPXbj1Zvd
         pc5IwMiAQ06FrRgz+BgpfeLG7h9k/cRZAR78gdSQuyiBpkUoWrWEP1sPNXQSSno0FnaY
         yMUd4K8sxCLvXwDywzj4Mskp0IPtuXow2eCdEIxgW8AY+YX93t6zeuCS+ANgYg6lpXuL
         6hNIOsZiiHe5fPxjg/EWDCfxv9JwwGv76RGy6fhcRithMBnw6IdkaqFSjLh72095gxHg
         KLng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YKLdTIejgEKY8NvlEMEihS6IUYygfbj/x16/G0vBSQc=;
        b=P6koPJE46A7kjeIFYlqYRnyZ8QVX2ZpVpQNLl6JSs5kWpyZv4IVbWDWxlwC0/jkk5m
         HVNaoxXVtwsKucV664XWByfcMQ9bvy/YCIu1o/O/b4gzOae2cymT7pJeRJrhI9VTy23Q
         89cPTecNZI/qg3ZRQHU3EPPMNvlPULhnYJ2XWrF0a39vpE0gC6MOG3InPYTU0MgkuL3m
         MXTpgXZKnajJGi45n4d5+25zMcP6E0ag7jb/kPAmwwaSiKP/W8S78LzYZN5MJf4TAWHT
         nC7T28c6MBdPGe8jW1xZ+r8AkUTmrxNGRSmuAJLoFxz2y8BjDObP84RJ3Fqi1hknj/C2
         FVOg==
X-Gm-Message-State: APjAAAX6U7C5V3X4OO08wbvj81Wl8BBudN7Rg457PWcOvBTEHaljiWNp
        xFP3bX7ttFXJpfGxDze4HOuRM/YPk4vTMSZ/pcY=
X-Google-Smtp-Source: APXvYqzKz0I8rYKtr1pIdQmm69V/mKGYkinlmk0VWKAOO7gKimt6AMJ6P4TO/YgeAptoEuSnY+mUZDqFXEgNouXnIoo=
X-Received: by 2002:aca:dd0b:: with SMTP id u11mr1947313oig.24.1552488111217;
 Wed, 13 Mar 2019 07:41:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:6a97:0:0:0:0:0 with HTTP; Wed, 13 Mar 2019 07:41:50
 -0700 (PDT)
In-Reply-To: <20190313140607.GE2003@redhat.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
 <20190313091252.GB2663@redhat.com> <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com> <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
 <20190313140607.GE2003@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 13 Mar 2019 15:41:50 +0100
Message-ID: <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
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
> On Wed, Mar 13, 2019 at 02:48:01PM +0100, Tom Psyborg wrote:
>> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > On Wed, Mar 13, 2019 at 02:02:32PM +0100, Tom Psyborg wrote:
>> >> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> >> > On Tue, Mar 12, 2019 at 08:11:42PM +0100, Tomislav Po=C5=BEega wrot=
e:
>> >> >> MFP can work with enabled HW crypt engine, but in this case
>> >> >> available bandwidth is reduced at least when connecting to
>> >> >> Archer C7 (QCA9558). Enable the feature for known to work chipsets=
-
>> >> >> MT7620, RT3070 and RT5390. Userspace setting for ieee80211w should
>> >> >> default to 0 in order to prevent unintentional bandwidth drop.
>> >> >>
>> >> >> Signed-off-by: Tomislav Po?ega <pozega.tomislav@gmail.com>
>> >> >> ---
>> >> >>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   11 +++++++----
>> >> >>  1 files changed, 7 insertions(+), 4 deletions(-)
>> >> >>
>> >> >> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> >> >> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> >> >> index a03b528..bb8204d 100644
>> >> >> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> >> >> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> >> >> @@ -9326,6 +9326,13 @@ static int rt2800_probe_hw_mode(struct
>> >> >> rt2x00_dev
>> >> >> *rt2x00dev)
>> >> >>  	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
>> >> >>  	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
>> >> >>
>> >> >> +	/* Experimental: Set MFP with HW crypto enabled. */
>> >> >> +	if (rt2x00_rt(rt2x00dev, RT3070) || rt2x00_rt(rt2x00dev, RT5390)
>> >> >> ||
>> >> >> +	    rt2x00_rt(rt2x00dev, RT6352))
>> >> >> +		ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
>> >> >
>> >> > Is not that we support MFP in hardware. We just return -EOPNOTSUPP
>> >> > in rt2x00mac_set_key() when mac80211 will try to set MFP ciphers
>> >> > (since rt2x00crypto_key_to_cipher() will return CIPHER_NONE) and
>> >> > we fallback to software encryption.
>> >> >
>> >> > Please repost patch that enable MFP unconditionally with
>> >> > 'Cc: stable@vger.kernel.org' tag.
>> >> >
>> >> > Stanislaw
>> >> >
>> >>
>> >> No, I have not test any other chipsets besides the ones I enabled it
>> >> for. It is possible this would cause problems on other devices, so
>> >> just enable it for the known to work ones.
>> >
>> > It's just matter of sending already encrypted frames. All chipsets
>> > handle that.
>> >
>> > Stanislaw
>> >
>>
>> The question is how well all chipsets handle that. I've seen some lags
>> too with MFP enabled connection. While being about 40-50% lower,
>> throughput would still occasionally drop to very low values, like
>> 800Kbps.
>
> The only reason I can image that might have impact on throughput
> in this case is limited CPU power since encryption is done in
> software. Would be good to compare with PA2 with nohwcrypte, if
> there are similar lags. However MFP can require more CPU power.
>
> Stanislaw
>

nohwcrypt=3Dy mfp=3Drequire: there was no throughput drop, no lag,
measured about 80-85Mbps but the connection frozen after a minute or
two. might be related to rekeying.

CPU power cannot be the problem since I run it on laptop (2x2.20GHz)

hwcrypt enabled results are low, some lag but connection remained stable:

root@OpenWrt:~# iperf -c 192.168.1.2 -i 1 -t 20 -P 4
------------------------------------------------------------
Client connecting to 192.168.1.2, TCP port 5001
TCP window size: 43.8 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.1 port 36274 connected with 192.168.1.2 port 5001
[  5] local 192.168.1.1 port 36276 connected with 192.168.1.2 port 5001
[  3] local 192.168.1.1 port 36272 connected with 192.168.1.2 port 5001
[  6] local 192.168.1.1 port 36278 connected with 192.168.1.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 1.0 sec  1.00 MBytes  8.39 Mbits/sec
[  5]  0.0- 1.0 sec  1.00 MBytes  8.39 Mbits/sec
[  3]  0.0- 1.0 sec  1.00 MBytes  8.39 Mbits/sec
[  6]  0.0- 1.0 sec  1.00 MBytes  8.39 Mbits/sec
[SUM]  0.0- 1.0 sec  4.00 MBytes  33.6 Mbits/sec
[  4]  1.0- 2.0 sec   896 KBytes  7.34 Mbits/sec
[  3]  1.0- 2.0 sec   896 KBytes  7.34 Mbits/sec
[  5]  1.0- 2.0 sec   896 KBytes  7.34 Mbits/sec
[  6]  1.0- 2.0 sec   896 KBytes  7.34 Mbits/sec
[SUM]  1.0- 2.0 sec  3.50 MBytes  29.4 Mbits/sec
[  5]  2.0- 3.0 sec   896 KBytes  7.34 Mbits/sec
[  4]  2.0- 3.0 sec   896 KBytes  7.34 Mbits/sec
[  3]  2.0- 3.0 sec   896 KBytes  7.34 Mbits/sec
[  6]  2.0- 3.0 sec   896 KBytes  7.34 Mbits/sec
[SUM]  2.0- 3.0 sec  3.50 MBytes  29.4 Mbits/sec
[  4]  3.0- 4.0 sec   896 KBytes  7.34 Mbits/sec
[  5]  3.0- 4.0 sec   896 KBytes  7.34 Mbits/sec
[  3]  3.0- 4.0 sec   896 KBytes  7.34 Mbits/sec
[  6]  3.0- 4.0 sec   896 KBytes  7.34 Mbits/sec
[SUM]  3.0- 4.0 sec  3.50 MBytes  29.4 Mbits/sec
[  4]  4.0- 5.0 sec   896 KBytes  7.34 Mbits/sec
[  5]  4.0- 5.0 sec   896 KBytes  7.34 Mbits/sec
[  3]  4.0- 5.0 sec   896 KBytes  7.34 Mbits/sec
[  6]  4.0- 5.0 sec   896 KBytes  7.34 Mbits/sec
[SUM]  4.0- 5.0 sec  3.50 MBytes  29.4 Mbits/sec
[  4]  5.0- 6.0 sec   896 KBytes  7.34 Mbits/sec
[  6]  5.0- 6.0 sec   896 KBytes  7.34 Mbits/sec
[  5]  5.0- 6.0 sec   896 KBytes  7.34 Mbits/sec
[  3]  5.0- 6.0 sec   896 KBytes  7.34 Mbits/sec
[SUM]  5.0- 6.0 sec  3.50 MBytes  29.4 Mbits/sec
[  4]  6.0- 7.0 sec   896 KBytes  7.34 Mbits/sec
[  5]  6.0- 7.0 sec   896 KBytes  7.34 Mbits/sec
[  3]  6.0- 7.0 sec   896 KBytes  7.34 Mbits/sec
[  6]  6.0- 7.0 sec   896 KBytes  7.34 Mbits/sec
[SUM]  6.0- 7.0 sec  3.50 MBytes  29.4 Mbits/sec
[  4]  7.0- 8.0 sec   896 KBytes  7.34 Mbits/sec
[  5]  7.0- 8.0 sec   896 KBytes  7.34 Mbits/sec
[  3]  7.0- 8.0 sec   896 KBytes  7.34 Mbits/sec
[  6]  7.0- 8.0 sec   896 KBytes  7.34 Mbits/sec
[SUM]  7.0- 8.0 sec  3.50 MBytes  29.4 Mbits/sec
[  6]  8.0- 9.0 sec   896 KBytes  7.34 Mbits/sec
[  4]  8.0- 9.0 sec  1.00 MBytes  8.39 Mbits/sec
[  5]  8.0- 9.0 sec  1.00 MBytes  8.39 Mbits/sec
[  3]  8.0- 9.0 sec  1.00 MBytes  8.39 Mbits/sec
[SUM]  8.0- 9.0 sec  3.88 MBytes  32.5 Mbits/sec
[  4]  9.0-10.0 sec   896 KBytes  7.34 Mbits/sec
[  5]  9.0-10.0 sec   896 KBytes  7.34 Mbits/sec
[  6]  9.0-10.0 sec  1.00 MBytes  8.39 Mbits/sec
[  3]  9.0-10.0 sec   896 KBytes  7.34 Mbits/sec
[SUM]  9.0-10.0 sec  3.62 MBytes  30.4 Mbits/sec
[  4] 10.0-11.0 sec   896 KBytes  7.34 Mbits/sec
[  3] 10.0-11.0 sec   896 KBytes  7.34 Mbits/sec
[  6] 10.0-11.0 sec   896 KBytes  7.34 Mbits/sec
[  5] 10.0-11.0 sec   896 KBytes  7.34 Mbits/sec
[SUM] 10.0-11.0 sec  3.50 MBytes  29.4 Mbits/sec
[  4] 11.0-12.0 sec   777 KBytes  6.36 Mbits/sec
[  5] 11.0-12.0 sec   797 KBytes  6.53 Mbits/sec
[  3] 11.0-12.0 sec   780 KBytes  6.39 Mbits/sec
[  6] 11.0-12.0 sec   785 KBytes  6.43 Mbits/sec
[SUM] 11.0-12.0 sec  3.06 MBytes  25.7 Mbits/sec
[  3] 12.0-13.0 sec   137 KBytes  1.12 Mbits/sec
[  4] 12.0-13.0 sec   148 KBytes  1.21 Mbits/sec
[  5] 12.0-13.0 sec   128 KBytes  1.05 Mbits/sec
[  6] 12.0-13.0 sec   128 KBytes  1.05 Mbits/sec
[SUM] 12.0-13.0 sec   541 KBytes  4.43 Mbits/sec
[  4] 13.0-14.0 sec   853 KBytes  6.99 Mbits/sec
[  5] 13.0-14.0 sec   853 KBytes  6.99 Mbits/sec
[  3] 13.0-14.0 sec   853 KBytes  6.99 Mbits/sec
[  6] 13.0-14.0 sec   852 KBytes  6.98 Mbits/sec
[SUM] 13.0-14.0 sec  3.33 MBytes  27.9 Mbits/sec
[  6] 14.0-15.0 sec   144 KBytes  1.18 Mbits/sec
[  4] 14.0-15.0 sec   145 KBytes  1.19 Mbits/sec
[  5] 14.0-15.0 sec   142 KBytes  1.17 Mbits/sec
[  3] 14.0-15.0 sec   147 KBytes  1.20 Mbits/sec
[SUM] 14.0-15.0 sec   578 KBytes  4.73 Mbits/sec
[  6] 15.0-16.0 sec   768 KBytes  6.29 Mbits/sec
[  4] 15.0-16.0 sec   768 KBytes  6.29 Mbits/sec
[  5] 15.0-16.0 sec   768 KBytes  6.29 Mbits/sec
[  3] 15.0-16.0 sec   768 KBytes  6.29 Mbits/sec
[SUM] 15.0-16.0 sec  3.00 MBytes  25.2 Mbits/sec
[  4] 16.0-17.0 sec   896 KBytes  7.34 Mbits/sec
[  5] 16.0-17.0 sec   896 KBytes  7.34 Mbits/sec
[  6] 16.0-17.0 sec   896 KBytes  7.34 Mbits/sec
[  3] 16.0-17.0 sec   896 KBytes  7.34 Mbits/sec
[SUM] 16.0-17.0 sec  3.50 MBytes  29.4 Mbits/sec
[  5] 17.0-18.0 sec   896 KBytes  7.34 Mbits/sec
[  6] 17.0-18.0 sec   896 KBytes  7.34 Mbits/sec
[  4] 17.0-18.0 sec   896 KBytes  7.34 Mbits/sec
[  3] 17.0-18.0 sec   896 KBytes  7.34 Mbits/sec
[SUM] 17.0-18.0 sec  3.50 MBytes  29.4 Mbits/sec
[  4] 18.0-19.0 sec   896 KBytes  7.34 Mbits/sec
[  5] 18.0-19.0 sec   896 KBytes  7.34 Mbits/sec
[  6] 18.0-19.0 sec   896 KBytes  7.34 Mbits/sec
[  3] 18.0-19.0 sec  1.00 MBytes  8.39 Mbits/sec
[SUM] 18.0-19.0 sec  3.62 MBytes  30.4 Mbits/sec
[  6] 19.0-20.0 sec  1.00 MBytes  8.39 Mbits/sec
[  6]  0.0-20.1 sec  16.1 MBytes  6.73 Mbits/sec
[  5] 19.0-20.0 sec  1.00 MBytes  8.39 Mbits/sec
[  5]  0.0-20.1 sec  16.1 MBytes  6.73 Mbits/sec
[  4] 19.0-20.0 sec  1.00 MBytes  8.39 Mbits/sec
[  4]  0.0-20.1 sec  16.1 MBytes  6.73 Mbits/sec
[  3] 19.0-20.0 sec   896 KBytes  7.34 Mbits/sec
[SUM] 19.0-20.0 sec  3.88 MBytes  32.5 Mbits/sec
[  3]  0.0-20.1 sec  16.1 MBytes  6.73 Mbits/sec
[SUM]  0.0-20.1 sec  64.5 MBytes  26.9 Mbits/sec


ubuntu@ubuntu:~$ iperf -c 192.168.1.1 -i 1 -t 20 -P 4
------------------------------------------------------------
Client connecting to 192.168.1.1, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.2 port 48396 connected with 192.168.1.1 port 5001
[  4] local 192.168.1.2 port 48398 connected with 192.168.1.1 port 5001
[  5] local 192.168.1.2 port 48400 connected with 192.168.1.1 port 5001
[  6] local 192.168.1.2 port 48402 connected with 192.168.1.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec   896 KBytes  7.34 Mbits/sec
[  5]  0.0- 1.0 sec   896 KBytes  7.34 Mbits/sec
[  4]  0.0- 1.0 sec   896 KBytes  7.34 Mbits/sec
[  6]  0.0- 1.0 sec   896 KBytes  7.34 Mbits/sec
[SUM]  0.0- 1.0 sec  3.50 MBytes  29.4 Mbits/sec
[  4]  1.0- 2.0 sec   384 KBytes  3.15 Mbits/sec
[  5]  1.0- 2.0 sec   384 KBytes  3.15 Mbits/sec
[  3]  1.0- 2.0 sec   384 KBytes  3.15 Mbits/sec
[  6]  1.0- 2.0 sec   384 KBytes  3.15 Mbits/sec
[SUM]  1.0- 2.0 sec  1.50 MBytes  12.6 Mbits/sec
[  5]  2.0- 3.0 sec   768 KBytes  6.29 Mbits/sec
[  6]  2.0- 3.0 sec   768 KBytes  6.29 Mbits/sec
[  4]  2.0- 3.0 sec   768 KBytes  6.29 Mbits/sec
[  3]  2.0- 3.0 sec   896 KBytes  7.34 Mbits/sec
[SUM]  2.0- 3.0 sec  3.12 MBytes  26.2 Mbits/sec
[  5]  3.0- 4.0 sec   384 KBytes  3.15 Mbits/sec
[  3]  3.0- 4.0 sec   256 KBytes  2.10 Mbits/sec
[  4]  3.0- 4.0 sec   384 KBytes  3.15 Mbits/sec
[  6]  3.0- 4.0 sec   384 KBytes  3.15 Mbits/sec
[SUM]  3.0- 4.0 sec  1.38 MBytes  11.5 Mbits/sec
[  3]  4.0- 5.0 sec   768 KBytes  6.29 Mbits/sec
[  4]  4.0- 5.0 sec   640 KBytes  5.24 Mbits/sec
[  6]  4.0- 5.0 sec   640 KBytes  5.24 Mbits/sec
[  5]  4.0- 5.0 sec   768 KBytes  6.29 Mbits/sec
[SUM]  4.0- 5.0 sec  2.75 MBytes  23.1 Mbits/sec
[  3]  5.0- 6.0 sec  1.12 MBytes  9.44 Mbits/sec
[  6]  5.0- 6.0 sec  1.38 MBytes  11.5 Mbits/sec
[  5]  5.0- 6.0 sec  1.25 MBytes  10.5 Mbits/sec
[  4]  5.0- 6.0 sec  1.38 MBytes  11.5 Mbits/sec
[SUM]  5.0- 6.0 sec  5.12 MBytes  43.0 Mbits/sec
[  4]  6.0- 7.0 sec  1.25 MBytes  10.5 Mbits/sec
[  5]  6.0- 7.0 sec  1.12 MBytes  9.44 Mbits/sec
[  3]  6.0- 7.0 sec  1.25 MBytes  10.5 Mbits/sec
[  6]  6.0- 7.0 sec  1.38 MBytes  11.5 Mbits/sec
[SUM]  6.0- 7.0 sec  5.00 MBytes  41.9 Mbits/sec
[  4]  7.0- 8.0 sec  1.38 MBytes  11.5 Mbits/sec
[  3]  7.0- 8.0 sec  1.25 MBytes  10.5 Mbits/sec
[  6]  7.0- 8.0 sec  1.38 MBytes  11.5 Mbits/sec
[  5]  7.0- 8.0 sec  1.38 MBytes  11.5 Mbits/sec
[SUM]  7.0- 8.0 sec  5.38 MBytes  45.1 Mbits/sec
[  6]  8.0- 9.0 sec  1.38 MBytes  11.5 Mbits/sec
[  3]  8.0- 9.0 sec  1.50 MBytes  12.6 Mbits/sec
[  5]  8.0- 9.0 sec  1.38 MBytes  11.5 Mbits/sec
[  4]  8.0- 9.0 sec  1.25 MBytes  10.5 Mbits/sec
[SUM]  8.0- 9.0 sec  5.50 MBytes  46.1 Mbits/sec
[  5]  9.0-10.0 sec  1.25 MBytes  10.5 Mbits/sec
[  4]  9.0-10.0 sec  1.12 MBytes  9.44 Mbits/sec
[  6]  9.0-10.0 sec  1.50 MBytes  12.6 Mbits/sec
[  3]  9.0-10.0 sec  1.38 MBytes  11.5 Mbits/sec
[SUM]  9.0-10.0 sec  5.25 MBytes  44.0 Mbits/sec
[  3] 10.0-11.0 sec  1.12 MBytes  9.44 Mbits/sec
[  6] 10.0-11.0 sec  1.38 MBytes  11.5 Mbits/sec
[  4] 10.0-11.0 sec  1.25 MBytes  10.5 Mbits/sec
[  5] 10.0-11.0 sec  1.25 MBytes  10.5 Mbits/sec
[SUM] 10.0-11.0 sec  5.00 MBytes  41.9 Mbits/sec
[  5] 11.0-12.0 sec  1.25 MBytes  10.5 Mbits/sec
[  4] 11.0-12.0 sec  1.38 MBytes  11.5 Mbits/sec
[  6] 11.0-12.0 sec  1.38 MBytes  11.5 Mbits/sec
[  3] 11.0-12.0 sec  1.38 MBytes  11.5 Mbits/sec
[SUM] 11.0-12.0 sec  5.38 MBytes  45.1 Mbits/sec
[  5] 12.0-13.0 sec  1.38 MBytes  11.5 Mbits/sec
[  6] 12.0-13.0 sec  1.25 MBytes  10.5 Mbits/sec
[  3] 12.0-13.0 sec  1.50 MBytes  12.6 Mbits/sec
[  4] 12.0-13.0 sec  1.25 MBytes  10.5 Mbits/sec
[SUM] 12.0-13.0 sec  5.38 MBytes  45.1 Mbits/sec
[  4] 13.0-14.0 sec  1.25 MBytes  10.5 Mbits/sec
[  5] 13.0-14.0 sec  1.12 MBytes  9.44 Mbits/sec
[  6] 13.0-14.0 sec  1.25 MBytes  10.5 Mbits/sec
[  3] 13.0-14.0 sec  1.38 MBytes  11.5 Mbits/sec
[SUM] 13.0-14.0 sec  5.00 MBytes  41.9 Mbits/sec
[  3] 14.0-15.0 sec  1.12 MBytes  9.44 Mbits/sec
[  6] 14.0-15.0 sec  1.38 MBytes  11.5 Mbits/sec
[  4] 14.0-15.0 sec  1.38 MBytes  11.5 Mbits/sec
[  5] 14.0-15.0 sec  1.25 MBytes  10.5 Mbits/sec
[SUM] 14.0-15.0 sec  5.12 MBytes  43.0 Mbits/sec
[  6] 15.0-16.0 sec  1.00 MBytes  8.39 Mbits/sec
[  4] 15.0-16.0 sec  1.00 MBytes  8.39 Mbits/sec
[  5] 15.0-16.0 sec   896 KBytes  7.34 Mbits/sec
[  3] 15.0-16.0 sec  1.00 MBytes  8.39 Mbits/sec
[SUM] 15.0-16.0 sec  3.88 MBytes  32.5 Mbits/sec
[  6] 16.0-17.0 sec   384 KBytes  3.15 Mbits/sec
[  3] 16.0-17.0 sec   256 KBytes  2.10 Mbits/sec
[  5] 16.0-17.0 sec   256 KBytes  2.10 Mbits/sec
[  4] 16.0-17.0 sec   384 KBytes  3.15 Mbits/sec
[SUM] 16.0-17.0 sec  1.25 MBytes  10.5 Mbits/sec
[  4] 17.0-18.0 sec   896 KBytes  7.34 Mbits/sec
[  6] 17.0-18.0 sec  1.00 MBytes  8.39 Mbits/sec
[  5] 17.0-18.0 sec  1.00 MBytes  8.39 Mbits/sec
[  3] 17.0-18.0 sec  1.00 MBytes  8.39 Mbits/sec
[SUM] 17.0-18.0 sec  3.88 MBytes  32.5 Mbits/sec
[  3] 18.0-19.0 sec   256 KBytes  2.10 Mbits/sec
[  4] 18.0-19.0 sec   256 KBytes  2.10 Mbits/sec
[  5] 18.0-19.0 sec   256 KBytes  2.10 Mbits/sec
[  6] 18.0-19.0 sec   256 KBytes  2.10 Mbits/sec
[SUM] 18.0-19.0 sec  1.00 MBytes  8.39 Mbits/sec
[  6] 19.0-20.0 sec  1.38 MBytes  11.5 Mbits/sec
[  6]  0.0-20.1 sec  20.8 MBytes  8.65 Mbits/sec
[  4] 19.0-20.0 sec  1.12 MBytes  9.44 Mbits/sec
[  4]  0.0-20.1 sec  19.6 MBytes  8.18 Mbits/sec
[  3] 19.0-20.0 sec  1.38 MBytes  11.5 Mbits/sec
[  3]  0.0-20.1 sec  20.1 MBytes  8.38 Mbits/sec
[  5] 19.0-20.0 sec  1.38 MBytes  11.5 Mbits/sec
[SUM] 19.0-20.0 sec  5.25 MBytes  44.0 Mbits/sec
[  5]  0.0-20.1 sec  19.6 MBytes  8.17 Mbits/sec
[SUM]  0.0-20.1 sec  80.1 MBytes  33.4 Mbits/sec
