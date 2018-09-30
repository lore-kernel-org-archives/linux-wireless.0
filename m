Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4C6C004D2
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 673DD206B7
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:43:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Z9Z1ra1j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 673DD206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbeI3QP5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 12:15:57 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:33310 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbeI3QP5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 12:15:57 -0400
Received: by mail-wr1-f43.google.com with SMTP id f10-v6so10634404wrs.0;
        Sun, 30 Sep 2018 02:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:from:to:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l0tml7J4oPPIbXIUU+biHi/4zEqV1uDLy89VbKIeEiQ=;
        b=Z9Z1ra1jrZt4H8UVeTxM5g2as7Xfh4jhSv5haALEWhO34wZD8KrkI6/9vm4wnkxyzD
         MsfXbwiFZtw27rvG3ZQ5f0ByAn8Z5h8DPM3iGtICfYMjRIrwBkvL9TtpfbdnwRoHxOIO
         VX7NDpLnlVUokIKKQ2wyksVjHOxa1/twO40HDb+N1lDeODaDoLCz6amrWPysKlQZxJpp
         7XH7ilbMM1N6VFUMpoKlnrnXNNT/513p2T57TlguVIDUOo0XHHIB5azYPxNdFjDlaer2
         X1jCzPYdohnchRHsv9v0YqW+iRDv+r3iEyAaqD5zam9gb1c5PLAQAty+XGwpINOwXtzu
         Ez6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=l0tml7J4oPPIbXIUU+biHi/4zEqV1uDLy89VbKIeEiQ=;
        b=oKlKbijRqsxKfXDScvszjzuU3yb2hzRWPMpR4Lh8e2qRA2xBfEJFRJEJe29LG9U6Ma
         awF+hHNexs9c7C1tDwjdhZNqiUHR1edBG4LDv3CSJhd2PRqTV5s/oC4JFJUrAVF+znxx
         TYTcFFcyTzEma/u50uJSQi65+dM0Qww+CDvZfDXPf9ldWvGJ4qsbCyZeITe0qX8JZ+lY
         EO9DlzCYPyT3fwYy77gP2H/kcElG97FErDpwU9rwSxmmpkQoVoW56w/kG6SyKsZPw+PV
         WviUEA2nTacblVS3qOUCQAQ0XL7ZKWOWTKR08U/g1PrfizXJB/fzq8Gmibr8MTzqfiLh
         LHIg==
X-Gm-Message-State: ABuFfogk18p54QiRQaAXFKRNKWJV+uG0+qvW/DEQ7YIslHH0s+rNNFUC
        kt7JppzacdceesX6rUq9XfbxVmUs
X-Google-Smtp-Source: ACcGV60YbV82cMotFndnGL9mggaz0C+/l+mPIoHNMdZKM9/S5K7u92wv78uR26EuNRj4Ou4rqyUjTQ==
X-Received: by 2002:a5d:4292:: with SMTP id k18-v6mr3778753wrq.225.1538300617622;
        Sun, 30 Sep 2018 02:43:37 -0700 (PDT)
Received: from [192.168.200.12] (p57B63A04.dip0.t-ipconnect.de. [87.182.58.4])
        by smtp.gmail.com with ESMTPSA id v21-v6sm18038544wrd.4.2018.09.30.02.43.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Sep 2018 02:43:37 -0700 (PDT)
Subject: Re: SIOCGIWRATE (and others) leaking SLAB (kmalloc-2048)
From:   Stefan Seyfried <stefan.seyfried@googlemail.com>
To:     LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
References: <cfbf778f-8817-a6f4-f56a-680f13ef5723@message-id.googlemail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=stefan.seyfried@googlemail.com; prefer-encrypt=mutual;
 keydata=
 xsDiBDqoB5ARBACZn/K+5V0uoo0Wr9cI9hw5vPioOmIbPv30x47j/w/XNECPSzos078v9Fr2
 Mlz0MG9Gnpl9S1o0OIh//K5xxj2/LRLO2nL9/nqlnwmJ6W5qrjjn6Ch3mxz5mxMeRMRMY1cZ
 EkSj7GH3ZLviZlzrnpuJd12HWsXhAwVxUyQnvsvNzwCgpIO6EfQT33o9illpG/AxIk2Uu0cD
 /A4cgKbm5VZW5DPTlLe8P92eEgj5cN51SUXHXYgWBI0Fx+QwSYm6ON0U03B4oR5zDWMHkJfZ
 WgXROdwY/NqouBoV7lXvHsyInPzExNixe+1vcrhDJ3ow6nlCW77aCFp22iwumC4ouzFtOMXK
 kih0WPrxPKq27Hw9fq9EaR2oV2tUBACN6ZC+G7J21ruG9slJ+bFcY5cW7M5Um6Czk08T+vtd
 7fAg+fEUcGCtIdVdHrXBut07K9y6iy5IuqwAV5fJsE+JQO+f+X1pymdRgdWHGEoMMdEW4k3W
 IGjrmmMUtpqzr30h4WFgA4+0nR3jpmcGCWBSa4selQecyyOlM7rcmKyQNs0kU3RlZmFuIFNl
 eWZyaWVkIDxzZWlmZUBvcGVuc3VzZS5vcmc+wmAEExECACAFAkx9Sb0CGyMGCwkIBwMCBBUC
 CAMEFgIDAQIeAQIXgAAKCRAx00vNNldAmFZuAJ9xLbFShKeTTDgfwMUmO37qw07npACgmLIK
 fbArokRryKixiliTvxAgFHHOwE0EOqgHkhAEALGQaS9Hj25lKGsaTOMKMBBvjklv6brH8JdF
 WTA9dr37spc+PFFyc9686bcT+5nkbpjq3ndXUzGdGzfe0YwOlQh4fWXZT/oTXosIBqDWPShE
 ntDU8BX9JVqBBZwJ/ey+QF5tgYrICjCzp8S/mL6sqw8En4/AS84lulAoNJMJsUcDAAMFA/4p
 ik7hBklqJzYC7uNWZDL9dkYwIsUXM64kGenUhpgguLZvhuVeUeHU2iIsdTcNBbeBwvXgLnEu
 vVSdf4wtDwR7SjUYebymbGc/JLkXjqGntaWUr+wfHmAm3oXV2X+WFzZQJ+o8N5dJyBEUbrVX
 YvBD7wErgEuJAL+q/i28U9u7OcJGBBgRAgAGBQI6qAeSAAoJEDHTS802V0CYBL8An1gF2k4s
 UaMjAtoX/ixcOhAv44i4AJ9Yi+OgvhS8CbUp+XkI5Q352XU+BQ==
Message-ID: <97c6b1b3-d992-2466-81ee-b383ef7bd90c@message-id.googlemail.com>
Date:   Sun, 30 Sep 2018 11:43:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <cfbf778f-8817-a6f4-f56a-680f13ef5723@message-id.googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 30.09.18 um 11:24 schrieb Stefan Seyfried:
> Hi all,
> 
> I'm running the openSUSE provided latest rc kernels and found, that
> after 2 weeks, about 4GB of memory had leaked into kmalloc-2048.
> Investigating with trace-cmd lead me to the gkrellm-wifi plugin, which
> periodically polls via wireless extension ioctls.
> 
> This is an easy to use reproducer:
> [...]
> 
> http://paste.opensuse.org/75377254
> 
> # grep ^kmalloc-2048 /proc/slabinfo
> kmalloc-2048 168090 168106 2048 2 1 : tunables 24 12 8 : slabdata 84053
>  84053 0
> # ./leak air
> # grep ^kmalloc-2048 /proc/slabinfo
> kmalloc-2048 178086 178086 2048 2 1 : tunables 24 12 8 : slabdata 89043
>  89043 0
> 
> The same happens with SIOCGIWSTATS and when reading /proc/net/wireless:
> 
> #!/bin/bash
> for ((i=0; i<10000; i++)); do
>         while read line; do :; done < /proc/net/wireless
> done
> 
> Thie lets me suspect an issue with rdev_get_station, but OTOH "iw air
> station dump" which I think also calls rdev_get_station via
> nl80211_get_station() does not seem to leak.

trace-cmd gives this for the above script:

  %99.28  (15289) leak.sh                        kmalloc #10001
         |
         --- *kmalloc*
          kmem_cache_alloc_trace
          cfg80211_sinfo_alloc_tid_stats
          sta_set_sinfo
          ieee80211_get_station
          cfg80211_wireless_stats
          wireless_dev_seq_show
          seq_read
          proc_reg_read
          __vfs_read
          vfs_read
          ksys_read
          do_syscall_64
          entry_SYSCALL_64_after_hwframe

("trace-cmd record -T -e kmalloc -f bytes_alloc==2048", then run the
script, then "trace-cmd hist trace.dat")

This points me to sta_set_sinfo and then to commit

commit 0fdf1493b41eb64fc7e8c8e1b8830a4bd8c4bbca
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri May 18 11:40:44 2018 +0200

    mac80211: allocate and fill tidstats only when needed

    This fixes memory leaks in the case where we just have the
    station info on the stack for internal usage without sending
    it to cfg80211.

which seems to be incomplete

> I did not see this with 4.18, I have noticed this with 4.19-rc3 after 13
> days and still see it with -rc5.

Looking at the commit, the bug might have been already in 4.18, which
I'm trying to confirm right now.
-- 
Stefan Seyfried

"For a successful technology, reality must take precedence over
 public relations, for nature cannot be fooled." -- Richard Feynman
