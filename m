Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=84.42.129.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792525114;
	b=CkPCySlKUddLxcE8CYq9Z7owuYcPJF/i/8xpVIl8TbY+XSrTOIHNpc2mqih2LGOOkl1r
	 OFNUSS/vk5HqY9GEBWOzSnJ2uZ4G0QbkJ6ot/BT4kwDxCGCTfUCcfceL8bdWy8DEHNzgk
	 DH4SBkyNBPJF6IVwEGVZTCjETq4bQYnzs/tKh8tQoRMQ/OPty2pd7TKhFAgahIiD4JLJi
	 oSOAwyYsorsg5kw8MEMmyT2rO65CZ+fT9qaA7zRvojC9SsVYk6qdg4YpsHZopuh79t8r4
	 0+loOtuq+SOLBgybgn30YWGUEzoyWhWni1JOm+0Eo5r2YUIES2T69j0g+1HVn2pRs7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792525114;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=y3oc0N552fH43ATGj4dRhIJ5VZELJgPpuDPjWuSNw44=;
	b=RKTp5OH1SGXxV8Hs7FsgJfMBYVTXnd68D6n6AKAaNxplsKHOICixNkowi3UcGuMe8eoj
	 Ok+/I3+I0VabQ1TBOg/yp29VO7EBSZplNrrWN1FbzLmXP5hPi5Z/Z9oBKaCAci9DyJ+TC
	 gaGELKtgOG4HzVQ1x6SkaIpdVwTwjv1fyNuoE2wuSvfxNN+qT7jWz0ILCNKMLlebyRdQY
	 NKR2jD4Vp8CBUqbwA90/MqPPZg6jHNoM5OmwOLdsccpxVo4z4finDcOJPUFjVL3P/1+hR
	 XtJj1FgAF9LOlktDevbb0mWepPf/nDaPEnT201W0odTPF+joADDQY0RtOld4EOYIO3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ixit.cz;
	spf=pass smtp.mailfrom=ixit.cz;
	dkim=pass header.d=ixit.cz header.i=@ixit.cz header.a=rsa-sha256 header.s=dkim header.b=F5BWplZD;
	arc=none smtp.remote-ip=84.42.129.46
Received: from ixit.cz (ixit.cz [84.42.129.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEDC606A319;
	Tue, 20 Oct 2026 19:38:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEEDC606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ixit.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ixit.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ixit.cz header.i=@ixit.cz header.a=rsa-sha256 header.s=dkim header.b=F5BWplZD
Received: from [IPV6:2a02:830a:f787:8f00:d622:eaa3:3dd6:8f5e] (unknown [IPv6:2a02:830a:f787:8f00:d622:eaa3:3dd6:8f5e])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ixit.cz (Postfix) with ESMTPSA id AC0BF534098B;
	Tue, 20 Oct 2026 21:38:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
	t=1792525105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y3oc0N552fH43ATGj4dRhIJ5VZELJgPpuDPjWuSNw44=;
	b=F5BWplZDBBPiCPe7Psv3d2lqQ5sQI5mWrNkQu0L6Ai7r1JTfQO1GOKjQIh4Y8Kphi8m05i
	rplpux6Oe5GDfARJ9xhdS2JkX6PCjhgA1mu5c9hZzqXto9c/exQEgLFXjykT7sEm9pHGSw
	wsH7Ofazd0uYsaCAv9wJdVucED9icqc=
Message-ID: <b5a06692-59f9-4b51-bbbf-71af39ad1f14@ixit.cz>
Date: Tue, 20 Oct 2026 21:38:25 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath10k: fix status of bundled mgmt tx
 completions
To: shunsuke@nagashi.ma, Jeff Johnson <jjohnson@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
 ath10k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260927-ath10k-bundle-status-v1-1-a1eea048ada9@nagashi.ma>
Content-Language: en-US, cs-CZ
From: David Heidelberg <david@ixit.cz>
Autocrypt: addr=david@ixit.cz; keydata=
 xsFNBF5v1x4BEADS3EddwsNsvVAI1XF8uQKbdYPY/GhjaSLziwVnbwv5BGwqB1tfXoHnccoA
 9kTgKAbiXG/CiZFhD6l4WCIskQDKzyQN3JhCUIxh16Xyw0lECI7iqoW9LmMoN1dNKcUmCO9g
 lZxQaOl+1bY/7ttd7DapLh9rmBXJ2lKiMEaIpUwb/Nw0d7Enp4Jy2TpkhPywIpUn8CoJCv3/
 61qbvI9y5utB/UhfMAUXsaAgwEJyGPAqHlC0YZjaTwOu+YQUE3AFzhCbksq95CwDz4U4gdls
 dmv9tkATfu2OmzERZQ6vJTehK0Pu4l5KmCAzYg42I9Dy4E6b17x6NncKbcByQFOXMtG0qVUk
 F1yeeOQUHwu+8t3ZDMBUhCkRL/juuoqLmyDWKMc0hKNNeZ9BNXgB8fXkRLWEUfgDXsFyEkKp
 NxUy5bDRlivf6XfExnikk5kj9l2gGlNQwqROti/46bfbmlmc/a2GM4k8ZyalHNEAdwtXYSpP
 8JJmlbQ7hNTLkc3HQLRsIocN5th/ur7pPMz1Beyp0gbE9GcOceqmdZQB80vJ01XDyCAihf6l
 AMnzwpXZsjqIqH9r7T7tM6tVEVbPSwPt4eZYXSoJijEBC/43TBbmxDX+5+3txRaSCRQrG9dY
 k3mMGM3xJLCps2KnaqMcgUnvb1KdTgEFUZQaItw7HyRd6RppewARAQABzSBEYXZpZCBIZWlk
 ZWxiZXJnIDxkYXZpZEBpeGl0LmN6PsLBlAQTAQgAPgIbAwULCQgHAgYVCgkICwIEFgIDAQIe
 AQIXgBYhBNd6Cc/u3Cu9U6cEdGACP8TTSSByBQJl+KksBQkPDaAOAAoJEGACP8TTSSBy6IAQ
 AMqFqVi9LLxCEcUWBn82ssQGiVSDniKpFE/tp7lMXflwhjD5xoftoWOmMYkiWE86t5x5Fsp7
 afALx7SEDz599F1K1bLnaga+budu55JEAYGudD2WwpLJ0kPzRhqBwGFIx8k6F+goZJzxPDsf
 loAtXQE62UvEKa4KRRcZmF0GGoRsgA7vE7OnV8LMeocdD3eb2CuXLzauHAfdvqF50IfPH/sE
 jbzROiAZU+WgrwU946aOzrN8jVU+Cy8XAccGAZxsmPBfhTY5f2VN1IqvfaRdkKKlmWVJWGw+
 ycFpAEJKFRdfcc5PSjUJcALn5C+hxzL2hBpIZJdfdfStn+DWHXNgBeRDiZj1x6vvyaC43RAb
 VXvRzOQfG4EaMVMIOvBjBA/FtIpb1gtXA42ewhvPnd5RVCqD9YYUxsVpJ9d+XsAy7uib3BsV
 W2idAEsPtoqhVhq8bCUs/G4sC2DdyGZK8MRFDJqciJSUbqA+5z1ZCuE8UOPDpZKiW6H/OuOM
 zDcjh0lOzr4p+/1TSg1PbUh7fQ+nbMuiT044sC1lLtJK0+Zyn0GwhR82oNM4fldNsaHRW42w
 QGD35+eNo5Pvb3We5XRMlBdhFnj7Siggp4J8/PJ6MJvRyC+RIJPGtbdMB2/RxWunFLn87e5w
 UgwR9jPMHAstuTR1yR23c4SIYoQ2fzkrRzuazsFNBF5v1x4BEADnlrbta2WL87BlEOotZUh0
 zXANMrNV15WxexsirLetfqbs0AGCaTRNj+uWlTUDJRXOVIwzmF76Us3I2796+Od2ocNpLheZ
 7EIkq8budtLVd1c06qJ+GMraz51zfgSIazVInNMPk9T6fz0lembji5yEcNPNNBA4sHiFmXfo
 IhepHFOBApjS0CiOPqowYxSTPe/DLcJ/LDwWpTi37doKPhBwlHev1BwVCbrLEIFjY0MLM0aT
 jiBBlyLJaTqvE48gblonu2SGaNmGtkC3VoQUQFcVYDXtlL9CVbNo7BAt5gwPcNqEqkUL60Jh
 FtvVSKyQh6gn7HHsyMtgltjZ3NKjv8S3yQd7zxvCn79tCKwoeNevsvoMq/bzlKxc9QiKaRPO
 aDj3FtW7R/3XoKJBY8Hckyug6uc2qYWRpnuXc0as6S0wfek6gauExUttBKrtSbPPHiuTeNHt
 NsT4+dyvaJtQKPBTbPHkXpTO8e1+YAg7kPj3aKFToE/dakIh8iqUHLNxywDAamRVn8Ha67WO
 AEAA3iklJ49QQk2ZyS1RJ2Ul28ePFDZ3QSr9LoJiOBZv9XkbhXS164iRB7rBZk6ZRVgCz3V6
 hhhjkipYvpJ/fpjXNsVL8jvel1mYNf0a46T4QQDQx4KQj0zXJbC2fFikAtu1AULktF4iEXEI
 rSjFoqhd4euZ+QARAQABwsF8BBgBCAAmAhsMFiEE13oJz+7cK71TpwR0YAI/xNNJIHIFAmX4
 qVAFCQ8NoDIACgkQYAI/xNNJIHKN4A/+Ine2Ii7JiuGITjJkcV6pgKlfwYdEs4eFD1pTRb/K
 5dprUz3QSLP41u9OJQ23HnESMvn31UENk9ffebNoW7WxZ/8cTQY0JY/cgTTrlNXtyAlGbR3/
 3Q/VBJptf04Er7I6TaKAmqWzdVeKTw33LljpkHp02vrbOdylb4JQG/SginLV9purGAFptYRO
 8JNa2J4FAQtQTrfOUjulOWMxy7XRkqK3QqLcPW79/CFn7q1yxamPkpoXUJq9/fVjlhk7P+da
 NYQpe4WQQnktBY29SkFnvfIAwqIVU8ix5Oz8rghuCcAdR7lEJ7hCX9bR0EE05FOXdZy5FWL9
 GHvFa/Opkq3DPmFl/0nt4HJqq1Nwrr+WR6d0414oo1n2hPEllge/6iD3ZYwptTvOFKEw/v0A
 yqOoYSiKX9F7Ko7QO+VnYeVDsDDevKic2T/4GDpcSVd9ipiKxCQvUAzKUH7RUpqDTa+rYurm
 zRKcgRumz2Tc1ouHj6qINlzEe3a5ldctIn/dvR1l2Ko7GBTG+VGp9U5NOAEkGpxHG9yg6eeY
 fFYnMme51H/HKiyUlFiE3yd5LSmv8Dhbf+vsI4x6BOOOq4Iyop/Exavj1owGxW0hpdUGcCl1
 ovlwVPO/6l/XLAmSGwdnGqok5eGZQzSst0tj9RC9O0dXO1TZocOsf0tJ8dR2egX4kxM=
In-Reply-To: <20260927-ath10k-bundle-status-v1-1-a1eea048ada9@nagashi.ma>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/09/2026 14:10, Shunsuke Nagashima via B4 Relay wrote:
> From: Shunsuke Nagashima <shunsuke@nagashi.ma>
> 
> ath10k_wmi_event_mgmt_tx_bundle_compl() takes the completion status of
> each report from desc_ids[i] instead of status[i]. Any non-zero status
> is handled as "not acked", so a bundled report is marked as acked if
> and only if its descriptor id is 0, whatever status the firmware
> returned.
> 
> The bundle handler read status[i] when it was added in
> commit cc123fac978f ("ath10k: Handle bundled tx completion for
> management frames"). The commit named in the Fixes tag replaced it
> with desc_ids[i].
> 
> Seen on WCN3990 in station mode with a WPA3-SAE AP. This firmware
> advertises mgmt-tx-by-reference and completes some management frames
> in bundles. A debug build printed status[] for each bundled report and
> could switch between the old and the fixed line. A sniffer watched the
> AP channel. The firmware status[] matched the capture in all 39
> bundled reports (15 with the old line, 24 with the fixed one): the 30
> frames with status[] 1 were never seen on that channel, and the 9
> frames with status[] 0 were acked.
> 
> With the old line, 6 of the 15 reports gave mac80211 the wrong ack
> result:
> 
>   - 4 frames that were never seen on the air were reported as acked.
>     Each report arrived after mac80211 had already timed out the
>     authentication, so they had no visible effect in these runs.
>   - 2 SAE commit frames that were acked on the air were reported as not
>     acked. They were the second and third of three tries. mac80211 gave
>     up on the authentication 239 us after the last report, although the
>     AP's SAE replies came about 5 to 8 ms later, so that connection
>     attempt failed.
> 
> Take the status from status[i].
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.2.0.c10-00459-QCAHLSWMTPLZ-1
> 
> Fixes: 4b816f170b1f ("ath10k: add support for ack rssi value of management tx packets")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM sparse
> Signed-off-by: Shunsuke Nagashima <shunsuke@nagashi.ma>
> ---
> Tested on a comma four (WCN3990) with a v7.2-based kernel
> (7.2.0-vamos-7626c37). It also carries three out-of-tree ath10k
> patches (MAC address, in-order rx A-MSDU, SET_KEY wait); none of
> them touch wmi.c or wmi-tlv.c.
> 
> - Debug build that prints status[] per bundled report and can switch
>    between the old and the fixed line, with a sniffer on the AP
>    channel: 6 connect/reconnect runs (5 WPA3-SAE, 1 WPA2-PSK),
>    39 bundled reports.
> - Build with only this patch: 6 connect/reconnect runs (5 WPA3-SAE,
>    1 WPA2-PSK), no debug output. No warnings, no firmware crashes.
>    One first connect failed and one reconnect was slow, for a
>    different reason that was also seen with the old line: the AP did
>    not ack, and the firmware held back some Auth frames.
> 
> Not tested: status 2 or 3 inside a bundle (only 0 and 1 were seen),
> AP mode, other chips and firmware versions.
> 
> I worked on this with Claude (claude-opus-5-5) and Codex
> (gpt-6-astra). They helped go through the logs and sniffer captures,
> write the debug build, and write the English of this changelog. I ran
> the tests on the device and reviewed the change myself.
> ---
>   drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: David Heidelberg <david@ixit.cz>

> 
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index e57588c19..67be6e817 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2512,7 +2512,7 @@ int ath10k_wmi_event_mgmt_tx_bundle_compl(struct ath10k *ar, struct sk_buff *skb
>   	for (i = 0; i < num_reports; i++) {
>   		memset(&param, 0, sizeof(struct mgmt_tx_compl_params));
>   		param.desc_id = __le32_to_cpu(arg.desc_ids[i]);
> -		param.status = __le32_to_cpu(arg.desc_ids[i]);
> +		param.status = __le32_to_cpu(arg.status[i]);
>   
>   		if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
>   			param.ack_rssi = __le32_to_cpu(arg.ack_rssi[i]);
> 
> ---
> base-commit: 753baa59527f8e606c49eac25692b8b08918a3a9
> change-id: 20260927-ath10k-bundle-status-24113117b683
> 
> Best regards,
> --
> Shunsuke Nagashima <shunsuke@nagashi.ma>
