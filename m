Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAF63E2746
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184548; cv=none; b=isUJo2RkelnVmRPcLtuWYnP2CEgGRecK2EnGApoBkBIuKmCL4j3JD3a05UgqCGChoy56ZruhExEZds6Z5bROyO6Gasx94M5ghXUr3Efwz3fcqON2dwUNNCheEs6RNEaquBS213YlX9Pg5CSLtQe7eqR/u6gE+AOaV+nX+X8Bfu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184548; c=relaxed/simple;
	bh=/sMURURWv1YZh61Ci3wNF200jZlP7/jjdbR9jjwqyVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D5LnO9HCumo5vtG6YeY0ADMWnzGY8ofKoNxYKw6VNA+t6cEB+yo4DsOfkG3KueAJThrhrKR6xxdKAONehuawJL1uSp1U6SxBbuwwzR5etE1ZJQKDuM6OgHUbVYv9ZwNYRaXLfShZR2angLrsMesU/TPZwnZ+crUDptLvKHY4ZUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VnHptfk3; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VnHptfk3"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso8792045e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 10:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790184544; x=1790789344; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lDMp6Yx2ju/oBvCEKgnuPJF7WmIwrSL9XyY2q4jm7z4=;
        b=VnHptfk3UA1PWtwtxXH5zmKtN/+NKXWqgB/eWu+4EPji99kXGtPso7Te9NqZ6FVUHv
         hOwKYBMtQxRuLwg9jgu/kY+pSda6V/bR6ENCK+m9o5xCyik5lZsG3kl+6FCfqk9tEBF7
         jUGOj1JcLHKB7myZ70HSW2GdOI85L/UGosrCzeoPBWBjYKWvDSOCWwBd5iBC+P8YJywX
         JS9ZqFgHxlMHwBOvKVo1k5BwqikZcmMTPA1s1DKABAwewvbVvhe6uwDwMT86cGTeniPs
         PKw6UqA2iPJo4LaFgdjRyWRNwNwptLJAfo1jiTeAScPcz13mUflVDjgjdUBOzLgitdJO
         tNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790184544; x=1790789344;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lDMp6Yx2ju/oBvCEKgnuPJF7WmIwrSL9XyY2q4jm7z4=;
        b=yPDzBLlneiXfE3HooZWQQgNHdyfJ/nXnUxBOYLE+5ggJOBRzkDcOFDHUe84Fsil8t1
         lsl4gXlfFnjOwxCFcCFw4eQ0u4LKjKCwWpbT5uJ6zM2TB7/j9gzt8FW9T82sefyj+s/v
         2OUSsmustml+Qg+5TSn3L7LeFATluDil3KchJvTSyr87rm0zak3a/HKpLKedR6ORIjMs
         JB9okRZ4+P5O7R/B5RqlCEg3w43hsD5/JwvcGxGwmSKbRqa7KlPYhAgJpv8KGHj6zNSh
         dvHEeBP2kRg8rp9ijDcWHQHR6yPuR7rFl3MjxRx5LdImXLQR9955bza0kZ1bMtypPm3Q
         XAXw==
X-Forwarded-Encrypted: i=1; AKwUvBzoy7SpVqI6UYYCPcz3tXfrD8SZNo1QiHaLGGdH1ZcNd1dIomaByP5qXbKfVVU+P/dD/PORmAsRTVbadmeO9A==@vger.kernel.org
X-Gm-Message-State: AFuF++ktFQPgZ95eLfSC9vfu9WSZKHKhaheiRaM3TO6TvdHKRhqRU+J5
	8dLajJh+s/Qrvl03eWcfdqmQlntcU6Zjxnw9hKspVZksMjW/8tO5CFirYTIcQg==
X-Gm-Gg: AYBFou1sUrkGjsFYuqJPU9R1+G8TDqCh7uOJPCtcoYZSBPo9CV5o4FkrKOsuHK8nSYw
	BQ3ky3OgNtTSZ8UUjWjvLHLU8sD+lWjuTUHpAw3b1UuWceh76wFjWgcDnVEQZl+XmwVB14I6A3S
	68xoR4vbXHEm/bjHcUKSlnRJ5WlNBuDgXnrFtALta4q/kNk8SHgqeIH8IwTRsx6VnNgPZS/CtOW
	NWHAgvzycj70r9U05NX4umvs8ymIyiHBI3EvKE9ze4Sb6ZF8NcE2iG5sA7wXluVENgdRSRxQNce
	0PcnOyFP+fOH4hHvNDO8C78OL5zEoVJIrCve6/PIF3a74XrvixoA9JdX67ju4qQUJZ/oPfKj/vK
	ZYrLrZdtYsnhGm/2dYIne94PtKj+cc3fD+PT2IPlZvPCaW71PPmP4/siYVPbVrtrHRCcScYTWab
	8eSxGLtrU2xYmifYnloCtCrrkicK5p19GGy8JyJ5fKW2eqAIorCnoo8+VRYPzr59lZ+ibbmKmRq
	X+w0F7S+GYGuD2kGg==
X-Received: by 2002:a05:600c:81c5:b0:49f:bd3c:bc1b with SMTP id 5b1f17b1804b1-49fdf13b84cmr42103415e9.22.1790184544199;
        Wed, 23 Sep 2026 10:29:04 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c3731fsm71718975e9.2.2026.09.23.10.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 10:29:03 -0700 (PDT)
Message-ID: <54d073e9-b40b-48e8-b0bb-3be2648a33ad@gmail.com>
Date: Wed, 23 Sep 2026 20:29:01 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com
References: <51079deb603845768db7cbe491f40e3c@realtek.com>
 <20260828033746.23039-1-abdurrahmankaradag19@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260828033746.23039-1-abdurrahmankaradag19@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/08/2026 06:37, Abdurrahman Karadag wrote:
>> Is there are version it works well on your platform?
>> I'm thinking bisect is a method to find cause.
> 
> Yes - and I have to correct my first mail, which said "also seen on
> 7.0.12". Going back through the system journal and pacman log:
> 
>   - 7.0.12 (Arch) ran on this laptop from 2026-06-16 to 2026-08-23. The
>     14 boots the journal holds from that period show no wedge episode
>     (defined as: DHCP lease acquired, then the gateway unreachable / DNS
>     failing continuously until reboot). The few candidates are either
>     sessions caught in the separate 63 s regulatory reconnect loop, or
>     sporadic DNS timeouts spread over hours-long otherwise-working
>     sessions (14-27 timeouts in 0.8-3.5 h), plus one 176 s blip - none is
>     the 100%-loss-until-reboot pattern.
>   - On 2026-08-23 18:41 pacman upgraded linux 7.0.12 -> 7.1.9 (in the same
>     transaction: linux-firmware-realtek 20260519 -> 20260810, whose
>     rtw8821c_fw.bin is byte-identical by sha256, and systemd 260.2 ->
>     261.2 a few minutes earlier).
>   - The first boot on 7.1.9 (2026-08-23 23:37) logged 12 wedge episodes,
>     and it has recurred on most days since.
> 
> So for a bisect: good = 7.0.12, bad = 7.1.9 (with the caveat that
> systemd changed in the same upgrade; I don't think networkd can explain
> a per-AC L2 TX failure, but I mention it for completeness). I still have
> the 7.0.12 package and can confirm by running it again for a few days,
> and I'm happy to bisect the rtw88/mac80211 range between the two if you
> think that's the right next step. (Under Windows the same laptop has
> never shown this.)
> 
>> The full cold power-off boot includes above two settings, right?
> 
> Yes. /etc/modprobe.d had "options rtw88_pci disable_aspm=y" and
> "options rtw88_core disable_lps_deep=y", initramfs rebuilt, full power
> off, and after boot both parameters read Y in /sys/module/. The wedge
> still happened on that boot.
> 
>> How did you measure the link? CAT-C?
> 
> Nothing special: 30-second windows of ping to the gateway plus
> "ip neigh" state and "iw dev wlan0 station dump" counters, while
> recording the delta of /sys/bus/pci/devices/0000:02:00.0/aer_dev_correctable
> and counting RxErr lines in the kernel log for the same window. Examples:
> one window had 0% loss with 6 new RxErr; another had 0% loss with 0
> RxErr; over that boot 329 RxErr accumulated while the link was fine. And
> the wedge itself occurred in a window with almost no RxErr. So I could
> not find any correlation in either direction.
> 
>> Can you setup another WiFi as monitor mode to capture 802.11 packets?
>> Use another WiFi monitor to see if RTL8821CE actually transmitted the packets.
> 
> Yes, I will. I need a second adapter for that; I'll do it on a 2.4 GHz
> 20 MHz network so a simple monitor-mode dongle is enough, and filter on
> the laptop's TA/RA. I'll report whether the ARP/BE frames appear on the
> air at all, and if they do, whether the AP ACKs them.
> 
>> I'm not sure why the size can affect the result. Normally large size
>> is harder to transmit basically though.
> 
> You are right, and I withdraw the size theory. Re-examining the same
> capture by 802.11 access category instead of size explains every frame
> with no exceptions:
> 
>   - every laptop TX frame that provably reached the AP carries IP DSCP
>     0xc0 (CS6 -> UP 6 -> AC_VO): the DHCP DISCOVER/REQUEST frames
>     (systemd-networkd's DHCP client marks them CS6) and IGMPv3 reports;
>   - every laptop TX frame that provably never arrived is AC_BE:
>     89 ARP requests (no IP header -> BE), 13 unicast ARP replies,
>     83 DNS queries (0 answers), 2 TCP SYNs (no SYN-ACK), mDNS/LLMNR;
>   - sizes overlap the wrong way for a size theory: BE frames of 42-201 B
>     all fail, VO frames of 54-345 B all pass.
> 
> So the wedge looks like "AC_BE TX dead, AC_VO TX alive", RX intact, and
> it persists across disconnect/reconnect and across AP changes (so not
> per-association state), cleared only by a reboot. It happened with
> power save fully off.
> 
> As far as I can tell from reading the driver, BE and VO take different
> paths (separate PCIe TX rings per AC, and on 8821C BE/BK on the LOW
> TX-FIFO queue vs VO/VI on NORMAL), so a per-AC stall - e.g. the BE ring's
> mac80211 queue left stopped, or the LOW queue paused/page-starved - would
> match what I see (BE frames silently aged out, VO flowing, no driver
> message). Does that sound plausible to you, or is there a more likely
> place for a per-AC TX stall on this chip? The monitor-mode capture
> should at least show whether BE frames reach the air at all.
> 
> When it wedges, besides the air capture, I plan to dump before rebooting:
> /sys/kernel/debug/ieee80211/phy0/queues (per-hw-queue stop reasons),
> stations/<ap>/aqm (per-TID backlog), and via rtw88 debugfs read_reg:
> REG_TXPAUSE (0x522), REG_TXDMA_STATUS (0x210), REG_FIFOPAGE_INFO_2/3
> (0x234/0x238) and the BE/VO TXBD indices (0x3A8/0x3A0), compared with a
> healthy baseline. If there are better registers or a debugfs page for
> the BE ring / LOW queue state on 8821C, please tell me and I'll dump
> those instead.
> 

Have a look at RTK_PCI_HISR0 and RTK_PCI_HISR1 too.

>> Please fully turn off power save when you do the tests to reduce one
>> factor that can possibly cause TX slowly or stuck.
> 
> Will do - power save stays off for all further tests.
> 
> Thanks a lot for looking at this.

