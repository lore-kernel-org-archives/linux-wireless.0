Received: from spe10-1.ucebox.co.za (spe10-1.ucebox.co.za [197.242.158.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E7336C59A
	for <linux-wireless@vger.kernel.org>; Sat,  2 May 2026 12:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=197.242.158.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777725682; cv=none; b=HuyDysE7kTNxErTq3VejLXfK1B/gzdn+cAUOQVbYzTdjHeJIE72EUVzKzc+LX0mNWHDVL+SX+PPLIan+7fjpuO3wMX3FrZ4O0woGnmWKim7NX9dI5eamklPEal+LWX+gml8vHoC5ErW+37cq94i00qc0khizrX+qpk4/oBkoqmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777725682; c=relaxed/simple;
	bh=wH5crqHc2v71D/zmoI4v0TW+AqNd2Jmca5ClEEtM13Q=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I0Zby20xbVJxSheapHwCEZs1NmOYNhNtgcmkpuQA/1VWldq2Y7AJeEOeAkzP0kXZkEm9nQ7CBxdhISbXL94W17P+YMbZypbkPu23EdkHQIBVLmzlClQ/8t61qQnPRIbyJW4m8IoMbKmx3ukgAJNMK3Sm46woonWbg4ibCAp+cFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hlope.org.za; spf=pass smtp.mailfrom=hlope.org.za; dkim=fail (0-bit key) header.d=hlope.org.za header.i=@hlope.org.za header.b=EX8lYk0A reason="key not found in DNS"; arc=none smtp.client-ip=197.242.158.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hlope.org.za
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hlope.org.za
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=hlope.org.za header.i=@hlope.org.za header.b="EX8lYk0A"
Received: from zulu.aserv.co.za ([154.0.174.187])
	by spe9.ucebox.co.za with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <developer@hlope.org.za>)
	id 1wJ9Hk-002ql8-4C
	for linux-wireless@vger.kernel.org; Sat, 02 May 2026 14:06:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=hlope.org.za; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Subject:To:From:Date:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qOh1sHfhVxTFmzw85CcuOAhkaidCGMh10W09gQJMkRc=; b=EX8lYk0AD1zcDTp2R2RhKGOoqh
	WS3q+df1ss3jKhoYTX83ekzPS01WlJgGsQTqtIPlo6D5uuZ+k2egHT+B4rSVlSaxvVzIleP3unRjc
	eSCFlG3gfODkFz3jc0mLLVFljzqV005H5ogsCVPL4wOQzRrmxOJ1wWLlyNsntCjoccLyPpJwA+veO
	4Q4CYguXcTWD4JZl4OMVxH0S0nd5MWwhskT8ADLiDjiNYmPL2TI8vlxBQZYAlNkl7Xkdj33dqZMNf
	/yoK7Rfp2839WTwSCjHqOe79ZbhUe8qSWOFpNbV31e3VVp17vckVtseyLkOZo+e3cCGmvO6lbyXf1
	1y5Qvr/Q==;
Received: from vc-vb-41-1-137-10.umts.vodacom.co.za ([41.1.137.10]:44662 helo=bongani-mini.home.org.za)
	by zulu.aserv.co.za with essmtpa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <developer@hlope.org.za>)
	id 1wJ96w-0000000G7iP-0Nef
	for linux-wireless@vger.kernel.org;
	Sat, 02 May 2026 14:06:17 +0200
Date: Sat, 2 May 2026 14:06:16 +0200
From: Bongani Hlope <developer@hlope.org.za>
To: linux-wireless@vger.kernel.org
Subject: Re: [BUG] wifi:  mt7902: NULL pointer dereference
Message-ID: <20260502140616.7672da98@bongani-mini.home.org.za>
In-Reply-To: <20260502125824.425d7159@bongani-mini.home.org.za>
References: <20260502125824.425d7159@bongani-mini.home.org.za>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Get-Message-Sender-Via: zulu.aserv.co.za: authenticated_id: developer@hlope.org.za
X-Authenticated-Sender: zulu.aserv.co.za: developer@hlope.org.za
X-Afrihost-Domain: zulu.aserv.co.za
X-Afrihost-Username: 154.0.174.187
Authentication-Results: ucebox.co.za; auth=pass smtp.auth=154.0.174.187@zulu.aserv.co.za
X-Afrihost-Outgoing-Class: ham
X-Afrihost-Outgoing-Evidence: Combined (0.16)
X-Recommended-Action: accept
X-Filter-ID: 9kzQTOBWQUFZTohSKvQbgI7ZDo5ubYELi59AwcWUnuUfiGyZnMcJfb3tsBJCIHrdkS4letCpk7Hu
 QVLuJP9sAiu2SmbhJN1U9FKs8X3+Nt1zK+WV213mG9v1wBG3CJSJghHNKUD0bxViKcuMBmKJGtCI
 EVI9LzXDA1Xh+DPG4pJ721XVFv93XkxBpVCGnwAMk31k9aIIh+zJRA1xOJoRUKPGxjczx15onleF
 Kw2Xyyt6ZP2tC/xa8XrsQTYQrzShD1u9kStEG9iVayg0+O5KG5yvQMuWkRBpkwdqZCCJb2JtsT/K
 rZZE9nYR6d54nf41nJrgScHt+gjdYMBYQipBHjaQjbZXf7r/xWkJ7iSXisGujs0bkUycDH5iINjY
 n9zMlgiIep8KAbjCsDfDj+RBNot+FdoyCIPSPe/oh71fzLJDijMFPnZFBcuVcyamH+Qv89Oj+GE+
 VAVQm7NSpkk4iH0ynLlsFFBEm/JwJ2rIW+sHimT4Bhx/ybDmXe6ulMv217NirEYyqwqMBGrw8ELi
 qMaLJL1323Ivn37aQLq/Mqp0EdgtRgwPbm413W9LZaUEEd+xWhZb9xdj272mxvfTgmzze7/TAKYm
 SdIyLr9rqTABIkUL/j1Y48GvmeURQjjEjmC44FRlAriYR7GP4Gv+Fambj1zNZF/OV3FRHcxOlKOQ
 AdNKczDKrz8lPm2r1FX4ke6La/x8LFup5ngfQ+W8SnQijq2JIXF/guA4Cu9rWvCWLi6/SX8BU7cZ
 1H5IENcmk2tm0NgI8ZGg3IECBeWGvrpiDZm+6MSLQ6iNPn2UepsZsa+QCP0JpgiYJ0CE+0qxp8vo
 240SSI8oxbBs7Y83vBxwEiTVJqDh0qKoKsXx5lktE/0pR1gcqnMo6qoc6bUybIczBOW8N2sUEqgp
 liH1pXq5oTMA2CLPMT/bcWJdaM+xudBLPLIRDZ2jZOwU70WP3jR5NeVaJQBh0uawl0Cg8gM+zmUy
 gjXuJS8HAYhk3NptLEmOAGOC0oNS96Ly85t+q+kcCSj1ttbdZaud8MmSZC+wkQEGUVEDEsD4pXKW
 ER0=
X-Report-Abuse-To: spam@spe1.ucebox.co.za
X-Complaints-To: abuse@spe1.ucebox.co.za

On Sat, 2 May 2026 12:58:24 +0200
Bongani Hlope <developer@hlope.org.za> wrote:

> Hello
> 
> I'm not sure if this has been reported yet, first ran into this on
> linux-next and it is still present on linux 7.1.0-rc1+. I get the
> following kernel Oops:

addr2line -e drivers/net/wireless/mediatek/mt76/mt7921/mt7921-common.ko
mt7921_channel_switch_rx_beacon+0x1f

Gives:
include/net/cfg80211.h:1016

Which is here:

 1007 static inline bool
 1008 cfg80211_chandef_identical(const struct cfg80211_chan_def *chandef1,
 1009                            const struct cfg80211_chan_def *chandef2)
 1010 {
 1011         return (chandef1->chan == chandef2->chan &&
 1012                 chandef1->width == chandef2->width &&
 1013                 chandef1->center_freq1 == chandef2->center_freq1 &&
 1014                 chandef1->freq1_offset == chandef2->freq1_offset &&
 1015                 chandef1->center_freq2 == chandef2->center_freq2 &&
 --> 1016                 chandef1->punctured == chandef2->punctured &&
 1017                 chandef1->s1g_primary_2mhz == chandef2->s1g_primary_2mhz);
 1018 }


8<

> Regards,
> Bongani Hlope
> 
> 

