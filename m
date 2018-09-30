Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF931C004D2
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8320E2075E
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:24:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Bi8aFapY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8320E2075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbeI3P4y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 11:56:54 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:53075 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbeI3P4y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 11:56:54 -0400
Received: by mail-wm1-f51.google.com with SMTP id 189-v6so5572361wmw.2;
        Sun, 30 Sep 2018 02:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=to:from:openpgp:autocrypt:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=FYvrDVxQm0eNb2VOzptFbukM6/kN2yqpJhIcB0wP34s=;
        b=Bi8aFapYBKDtqaAwuHMi6IivL6zSzAuYP/RvZ3eoR/FdBJ8V6rzslYwyfce35SQrQ5
         VepmrYwqoSLPB4Ztauf9D2PJWHhHbIrgPj5Z5aWGi4k4geZa528YHodqgj6qOzJoeRZ/
         y5ub5BT60uKgHNLbgWLSg1VwEbozlrf/j8jxIpedQBYBUZ0jss8RLJo0gCHNwLGgPdHY
         2/fg8G7Oz9QlSsf5Zqg2FS0lQXkZpZnu+Ylu2JD1J+mbE6f0qe+6MpZC6s5Y5gZs47zW
         9DQWPeOBV/sdFwP2iyPuGWS7POJfhTrxh4etF9CwHhAB+48Z/UV1CLLjzLBSrxXoy/oj
         WnsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:openpgp:autocrypt:subject:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=FYvrDVxQm0eNb2VOzptFbukM6/kN2yqpJhIcB0wP34s=;
        b=DYRqyHl7y6uQzldcU1LvmwkZAeoN9EarhkIIbdM12zzl0a8KgdUc7EGsfTwSOyrR77
         qmNu90jZjVH5oK6xuvGivHARXEUlICEryPJ0GZI2ffLm6H9k7ITuU40ZONcLfaMmmE2V
         YWuYNhQfEb/52qi/w3s8gs5ftANmFWKzhIYQ5S7p9e0D2Zh5Cf95TdVb1zfIPxCxuuPJ
         nsj+t6smA4UVepmBacjIQxA/zuZwdqHNR0N+NZ5QEGzWlRe6ofqVLc4QWWtF8WGNxr9i
         ioiQGL4HycsJz0vVp9xkON12IagcMlucbtyda5sOkcMiJiTgyRpz1Y6g86AEWY7edKYV
         M58A==
X-Gm-Message-State: ABuFfogyTCLhgD4bS+PuboxPd1FlcVCN+78xwf1ud6nlarhgbODhdP1S
        67P/R7ZImAD99f3YSpZfE1TWATTS
X-Google-Smtp-Source: ACcGV60f/SfR0Q3t91iocbOyHg2KS8MMLTyBR4C3tp9xeb56zuuC9b/vVyS7ZSS/DLDAwKZsAcIYVg==
X-Received: by 2002:a1c:14d1:: with SMTP id 200-v6mr6409830wmu.106.1538299479459;
        Sun, 30 Sep 2018 02:24:39 -0700 (PDT)
Received: from [192.168.200.12] (p57B63A04.dip0.t-ipconnect.de. [87.182.58.4])
        by smtp.gmail.com with ESMTPSA id l140-v6sm10947246wmb.24.2018.09.30.02.24.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Sep 2018 02:24:38 -0700 (PDT)
To:     LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
From:   Stefan Seyfried <stefan.seyfried@googlemail.com>
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
Subject: SIOCGIWRATE (and others) leaking SLAB (kmalloc-2048)
Message-ID: <cfbf778f-8817-a6f4-f56a-680f13ef5723@message-id.googlemail.com>
Date:   Sun, 30 Sep 2018 11:24:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi all,

I'm running the openSUSE provided latest rc kernels and found, that
after 2 weeks, about 4GB of memory had leaked into kmalloc-2048.
Investigating with trace-cmd lead me to the gkrellm-wifi plugin, which
periodically polls via wireless extension ioctls.

This is an easy to use reproducer:

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <linux/wireless.h>
int main(int argc, char **argv)
{
  struct iwreq request;
  int fd;
  if (argc < 2) {
    fprintf(stderr, "usage: %s <interface>\n", argv[0]);
    return 1;
  }
  fd = socket (AF_INET, SOCK_DGRAM, 0);
  if (fd < 0) {
    fprintf(stderr, "Could not open socket: %m\n");
    return 2;
  }
  strncpy (request.ifr_name, argv[1], IFNAMSIZ);
  for (int i = 0; i < 10000; i++)
    if (ioctl (fd, SIOCGIWRATE, &request) < 0)
      fprintf(stderr, "ioctl: %m\n");
  close (fd);
  return 0;
}

http://paste.opensuse.org/75377254

# grep ^kmalloc-2048 /proc/slabinfo
kmalloc-2048 168090 168106 2048 2 1 : tunables 24 12 8 : slabdata 84053
 84053 0
# ./leak air
# grep ^kmalloc-2048 /proc/slabinfo
kmalloc-2048 178086 178086 2048 2 1 : tunables 24 12 8 : slabdata 89043
 89043 0

The same happens with SIOCGIWSTATS and when reading /proc/net/wireless:

#!/bin/bash
for ((i=0; i<10000; i++)); do
        while read line; do :; done < /proc/net/wireless
done

Thie lets me suspect an issue with rdev_get_station, but OTOH "iw air
station dump" which I think also calls rdev_get_station via
nl80211_get_station() does not seem to leak.

I did not see this with 4.18, I have noticed this with 4.19-rc3 after 13
days and still see it with -rc5.

Best regards,

Stefan
-- 
Stefan Seyfried

"For a successful technology, reality must take precedence over
 public relations, for nature cannot be fooled." -- Richard Feynman
