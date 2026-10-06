Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373CE3859E2;
	Tue,  6 Oct 2026 09:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278044; cv=none; b=YDm7EkQvunzEJJR+Z6Y+FTo7VHMo6Qth5g+EQkhPda4MDBWVDv8luonH4w2RMoIefFxASgRmlKwe4kMfd7QeXCQDNKXp/WXi5ZdjCqKd06JwyqSxVFqnWkFEnm/SafEGmettYDmJ8wRg9Fh7Krhu5YgUQbUZw3DzHdvvXGDzdB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278044; c=relaxed/simple;
	bh=DrxJkpjzyYGp2CHDwYW5JhpYSnS/x/10mxjjG2cWEhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fYQpdezI8EI8cyLkijvlSdYbDMDyEpjlTB7BtIw0FKH3FXyQ/UOE2IDKKstnt8JDCI/eQ68fxkj7EntgQmVI8fBbYguleq+9EzGsAOjkqL3MuA7MlL+8elxcyNw5oiuZiU5ZjADFY3O+cis2glNEbrI2PbQzpLMOL7h8BHHcEvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fDkoxYHk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vtmyViQ4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rVjdZGvS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=R8xxy8iS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fDkoxYHk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vtmyViQ4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rVjdZGvS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="R8xxy8iS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7BC42219BB;
	Tue,  6 Oct 2026 09:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791278030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/JP5/dW09R5F2dsXZl8YQmvtpMPAD0rEIwWS4AD5kE=;
	b=fDkoxYHkVYr4W6YH5yRxqIrHXc73xkhaboCbMmp7NnxECOhN+ygj2bEuXWHiyJjf4bcz25
	GlYx3gG3NI+koiifofzeISimtBXmpdYjoBl9AkXjldl9V027t7OHggmFD3BNolBpeaPrvB
	HvJ2vhh5JinSm10f7+LvWSu4vywb2R8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791278030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/JP5/dW09R5F2dsXZl8YQmvtpMPAD0rEIwWS4AD5kE=;
	b=vtmyViQ4WfXPweEDJ5w+ZsSM5SFwt7aFu3EWSoegOPreAKK2a2T2+sFJ0GQcxfFoD1qHaB
	3isnzYCxfZhOKzCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rVjdZGvS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=R8xxy8iS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791278026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/JP5/dW09R5F2dsXZl8YQmvtpMPAD0rEIwWS4AD5kE=;
	b=rVjdZGvSE0olqXazD1zG6dWnRSutvJyeQKYMWVEf6GWvAYMZUkExtbMdKyRb5auiZgjyAb
	gXGBSR7uNdSvnkMINSXuXYNVE/hz5d+nXksnB9oBGu2Kj1Mbp+Ovdd8zVJrMemT5HmWXHr
	zZ64AlYry1BzcMqIs8xRYsjhhR38OvM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791278026;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/JP5/dW09R5F2dsXZl8YQmvtpMPAD0rEIwWS4AD5kE=;
	b=R8xxy8iSibgvaif20gQv6dsUZb+//Qwx97Yh+RMcUBpJH8DwCYTuamgYwOSJi0/XuYTYqX
	evqFsO/OncL/4MCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CAE17136F2;
	Tue,  6 Oct 2026 09:13:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pR6EJsm7xGoXSgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 06 Oct 2026 09:13:45 +0000
Message-ID: <ade9aa6a-ae47-4894-be43-2f32cc234afc@suse.de>
Date: Tue, 6 Oct 2026 11:12:40 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/16 net-next v3] ipv4: udp: split IPv4 specific logic
 into udp_ipv4.c
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260930135334.4739-7-fmancera@suse.de>
 <179113455115.434549.17562988532168582470@kernel.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <179113455115.434549.17562988532168582470@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TAGGED_RCPT(0.00)[sashiko];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7BC42219BB
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO



On 10/4/26 7:22 PM, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] When CONFIG_IPV4=n, udp4_gro_complete()
>    (net/ipv4/udp_offload.c) returns -EAFNOSUPPORT for every merged IPv4…
> 
> --
> 
> ipv4: udp: split IPv4 specific logic into udp_ipv4.c
> 
> This commit moves the IPv4-specific UDP socket code out of udp.c and into
> a new file, udp_ipv4.c. That covers lookup, input/output, multicast
> delivery and the AF_INET udp_prot. The new file is built only when
> CONFIG_IPV4 is enabled. Callers in af_inet.c, udp_bpf.c, udp_offload.c and
> ipv6/udp.c get IS_ENABLED(CONFIG_IPV4) guards.
> 
>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
>> index cf07c3c6611a2..bea037d6b4eb7 100644
>> --- a/net/ipv4/udp_offload.c
>> +++ b/net/ipv4/udp_offload.c
>> @@ -958,6 +958,9 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
>>   	const struct iphdr *iph = (struct iphdr *)(skb->data + offset);
>>   	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
>>
>> +	if (!IS_ENABLED(CONFIG_IPV4))
>> +		return -EAFNOSUPPORT;
>> +
> 
> [Severity: Medium]
> With CONFIG_IPV4=n, can this make every merged IPv4 UDP GRO packet get
> dropped silently?
> 
> The IPv4 GRO offloads are still registered when IPv4 is disabled.
> ipv4_offload_init() in af_inet.c still calls udpv4_offload_init() and
> dev_add_offload(&net_hotdata.ip_packet_offload) with no guard. So
> inet_gro_receive()->udp4_gro_receive()->udp_gro_receive() still runs for
> IPv4 UDP packets.
> 
> The socket lookup there ends up in the new __udp4_lib_lookup() stub,
> which returns NULL. Even so, udp_gro_receive() still aggregates:
> 
> 	if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
> 		NAPI_GRO_CB(skb)->is_flist = sk ? !udp_test_bit(GRO_ENABLED, sk) : 1;
> 
> 	if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
> 	    (sk && udp_test_bit(GRO_ENABLED, sk)) || NAPI_GRO_CB(skb)->is_flist)
> 		return call_gro_receive(udp_gro_receive_segment, head, skb);
> 
> At flush time, gro_complete()->inet_gro_complete()->udp4_gro_complete()
> now returns -EAFNOSUPPORT, and gro_complete() in net/core/gro.c frees
> the whole aggregate:
> 
> 	if (err) {
> 		WARN_ON(&ptype->list == head);
> 		kfree_skb(skb);
> 		return;
> 	}
> 
> The WARN_ON doesn't fire because a ptype was found, so all segments are
> lost with no warning. This would affect an IPv6-only kernel that bridges
> or forwards IPv4 UDP with NETIF_F_GRO_UDP_FWD or NETIF_F_GRO_FRAGLIST
> enabled on the ingress device. Inner IPv4 carried in IPv6 tunnels would
> be hit too.
> 
> The fraglist branch and the udp_gro_complete() path don't need IPv4
> socket state. The only IPv4-only dependency looks like the
> udp4_lib_lookup_skb reference. Would it work to stub or skip only the
> lookup, for example with a NULL-returning udp4_lib_lookup_skb when
> CONFIG_IPV4=n, and keep the rest of udp4_gro_complete()? Or should IPv4
> UDP GRO receive also be disabled in that configuration, so packets
> aren't aggregated only to be dropped at completion?
> 
> The later patch in the series, "ipv4: make CONFIG_IPV4 boolean", makes
> this configuration selectable. udp4_gro_complete() and
> ipv4_offload_init() are unchanged at the end of the series.
> 

I guess this is a good point. I will look more into it.

pw-bot: cr

>>   	/* do fraglist only if there is no outer UDP encap (or we already processed it) */
>>   	if (NAPI_GRO_CB(skb)->is_flist && !NAPI_GRO_CB(skb)->encap_mark) {
>>   		udp_set_len(uh, skb->len - nhoff);
> 
> [ ... ]
> 

