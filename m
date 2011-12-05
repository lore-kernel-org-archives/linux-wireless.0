Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34274 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab1LENnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 08:43:49 -0500
Received: by iakc1 with SMTP id c1so2121775iak.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2011 05:43:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOeh9MsqTQT6qzd47Af674cK4KQHN=uOaG-u1hVWV9faeb2Mwg@mail.gmail.com>
References: <CAOeh9MuuJtK_edMQvVaLSRytRoFix_OuW4OEcEMDYEak1=CvMw@mail.gmail.com>
	<CAB3XZEf=jrrqZk58BnV8Gi4iKJ6N6c24M_eLnz816n==kuxmHA@mail.gmail.com>
	<CAOeh9MsqTQT6qzd47Af674cK4KQHN=uOaG-u1hVWV9faeb2Mwg@mail.gmail.com>
Date: Mon, 5 Dec 2011 15:43:49 +0200
Message-ID: <CAB3XZEf4sm66WzG49jYsig=wzip0m2w87tud2Es0wd4aXV2Fqw@mail.gmail.com> (sfid-20111205_144353_128600_B97B011A)
Subject: Re: Query on ieee80211_subif_start_xmit
From: Eliad Peller <eliad@wizery.com>
To: uday kiran <kaniki.uday@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 5, 2011 at 3:14 PM, uday kiran <kaniki.uday@gmail.com> wrote:
> Thanks for the reply, Eliad.
>
> I have walked through the code for function
> "ieee80211_subif_start_xmit" but could not find any code block which
> strips the 802.3 header. If possible , could you help me point out
> that block ?
>
	skip_header_bytes = ETH_HLEN;
	if (ethertype == ETH_P_AARP || ethertype == ETH_P_IPX) {
		encaps_data = bridge_tunnel_header;
		encaps_len = sizeof(bridge_tunnel_header);
		skip_header_bytes -= 2;
	} else if (ethertype >= 0x600) {
		encaps_data = rfc1042_header;
		encaps_len = sizeof(rfc1042_header);
		skip_header_bytes -= 2;
	} else {
		encaps_data = NULL;
		encaps_len = 0;
	}

	nh_pos = skb_network_header(skb) - skb->data;
	h_pos = skb_transport_header(skb) - skb->data;

	skb_pull(skb, skip_header_bytes);

Eliad.
