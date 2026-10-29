Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793293637;
	b=3CdV8pWVfo8dvDwWZ2jYKgnnL3H0qNIArijCilfCj1znjXV9hmfhz2fOMlRIQ49N0VPs
	 SSfsAbgGRQCOGEGHJNI9H0zAus7rmV/wVwFDxCLazt013T3Z5jmzHMSmlmNkaq2VIv0wV
	 oGfKbI4IQmI1bbwyTGVDK/euvSbNXJi9Io/KSGKyqX01K6EiGtZ8daiw9cUeuEPBt5EAz
	 q13XmAFX2s3MYVIHK2k/ZyfvIE7k15489Fom96oFwwM7FgyZXc8hP8i48VJQQvfTFi8Eo
	 Z4WDLkU7N5dNtamu0p39/bLqE4DHSzCwTzIgZswbXTDvCZOiac8g0q1rVNPPaW9TijQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793293637;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=OTVGnfkTs6RbRcs7fJBR8apsCZVsWPRqsaWFjTMadng=;
	b=rfG1EHIzJ34Z0GFMWHF8juFaVELf4j7SpTf+vKlfUVcnUarN24X6jv179NvaREjZgIqU
	 6mb5ZoPDXB3khrDQ/oa5WDUagexGefiFKLUoBCNEc3FuuqYIdMy1hsFDBQH7msKsa9cir
	 AwvnYDksJR6Mf6noodGU53qkkbvad9RLURpTInTyEpEv6Rmu0Fdbw+iAmq8FVSej9N5xT
	 TiNOeYTWXuhXsgUf8UPKbdvTGN1xAyy1Bxqk0rqCEFNJkSPt2ma+ssT3+nraDS4RobPvz
	 aE3HhgdjeSAkgNgKq2FZGLUmI2TXMOmeOzFluDKc8u9ZDt9u1ryNp5u8AerJnJYY0eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bdwsf9YK;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RS2OLUaC;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9485606A31C
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 17:07:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9485606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bdwsf9YK;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RS2OLUaC
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TGDQKL594519
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 17:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OTVGnfkTs6RbRcs7fJBR8apsCZVsWPRqsaWFjTMadng=; b=bdwsf9YKZkntOrcW
	ifYsHdOBtxr62ScQAVlC9/WOBfFYLUt11D6rRekYiVNJVubOIm56cGsRAKNDJVnP
	9obgacnu9WfhMN4/zGr6nDVWe/+8cPGZn/PlhYi29XS0YzJAIWpCDimc5ntvOgMd
	r27cY7ARJqx1L/X7CMwmbb9qanZNvPD5AXLUug9NALsD7/CI8qQqkEtHlvkLKSKd
	Sn/vafZ1rCeS1bGhwJRFJaHYYyhTQl5p16CizOazYx/IGYwBlYmvougLBUQG2wnC
	z3CDpPvncp3jFNH4NgrGk5SOVvswVVqLQRkiOuT9jzsjesIQYRNQq/3i3x7LwNNj
	+7+m/A==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkut3kkxw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 17:07:15 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36637676140so3329213eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 10:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793293635; x=1793898435; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OTVGnfkTs6RbRcs7fJBR8apsCZVsWPRqsaWFjTMadng=;
        b=RS2OLUaC2ch66hultPMlFBFfD1TzPGAsRo2TefStI8edhsT/BWVhx81qA7aCxkRKG2
         OAKYwc0AMlaG3cJdbbXv+CD86VCSvWwbc/UbgWikJFfwXmd80tgFAG6gANIuIlavbtj1
         parnxRyvySKpxrfWVvHvmPOrDitPDnhdOi8TdzhLQKmEef9mSHNHQeN/Spmoqg/wF7ZX
         oFmN7aWj/TOBwTgpEwjhcsFbLcxY/Ic63e7PGG2YOIn9byhmDDxAGucdXAd/rnzsUrE2
         hxVtN8SEftIdttHcEVo8ykxMW18/5ka9j0ZK/I8MDvUcTilR1O7jqWXTNw7wrcT2F4rr
         hBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793293635; x=1793898435;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OTVGnfkTs6RbRcs7fJBR8apsCZVsWPRqsaWFjTMadng=;
        b=He3Tc165sfiwL4nTZFZn4KZ5TtHwqSvNNpqeMEYNOrPuAcEbVj3m7eGXEP1aqiLGbv
         co8Qg2t8u5zDr+lNlJJ5dit4R433HVzs8cwCmrvkjykeUhvC3ZYZSh2ts73ySDl/qDbv
         jOVaCFHaTBQq2QUwhPlzs0IEVI5aFxF6bzupKPjbmgjECRko+On6/SzbiVqTAPH+yJmI
         2FvRIacxcKrFi7nl8Qi1jr5L8ZdpE/MQNKUvpnOEsBkpHm1pwHzkKngttRqXUx8PFGCR
         at/UB0sQ5v7Ho2lRgXl01KLv0acGCBQ9qyRYUMq47MWyeQu0DJ0nQAgxYQzHZ1I2zA9a
         JZ7w==
X-Gm-Message-State: AFq9FYJip4hSGW5eTBlF6G25OcgwveL7heIf05aGDrlwmaIHUNfF1diu
	29zILCtDBySpvJ/z9CcGEZLo9gcjrlnANRXchC0o2St5ZoY/gol0jVElfuGRrvSCvIiJ+WJ1/61
	x8P4w4GHoC532rwq4HOp33QnLBj3ACkJLEA/U966XYQfvoYxMT1Qcv1geVoNJ/tAASVL85krjgj
	hK1g==
X-Gm-Gg: AYBFou3ov9uQtXopqbgk44zdL0DpXGZtj9ANQjS//A9/Fv3bKQHgDH3W0qYEbWYtq9b
	hri1JV7KzCUEEG3PoCL1K3lLNrdtmrAmfPpKeNRMMYeAwyeGPLJY2bHzZhQatgO5FjKHMU6SyNX
	CrGascSW0r/VsrC3Bv+j/YTB4dX3SMQAumVxZCNu8bOSdJEyboFUhP06Yxc5ZYKayI6wMmdZtxM
	CLqHcTxkFgKyxkP9ibzthoYZnTO7t6jMFNKWW/lViv1S+qk4DI+6gBO1Vk1DZami37nbW7t/n6E
	waEG+2OMVWlCOBT1yzBUzW4IuyIt+lH1WWhJUMtBSd6M2XtJpCAUQHZzf8hwsCui1T/WfUqt5jO
	ln6kocl7/8VzKvaxH3LoyrJJGL5UhMuIXAF775yVQI7GGbFgpcdD3sdyLLjQq3W67K09HdvWcKU
	tKyNU3divnKzKVBOfRb7MaL+LfdMDaznM=
X-Received: by 2002:a05:701b:281b:b0:153:3c50:ab85 with SMTP id a92af1059eb24-1a6ced8ff93mr7817929c88.12.1793293634930;
        Thu, 29 Oct 2026 10:07:14 -0700 (PDT)
X-Received: by 2002:a05:701b:281b:b0:153:3c50:ab85 with SMTP id a92af1059eb24-1a6ced8ff93mr7817885c88.12.1793293634193;
        Thu, 29 Oct 2026 10:07:14 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1abeb29e4b9sm418047c88.20.2026.10.29.10.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 10:07:13 -0700 (PDT)
Message-ID: <50b7909e-fa3e-4b90-8f1d-57a870890a69@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 10:07:12 -0700
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
Subject: Re: [PATCH wireless-next 09/15] wifi: nl80211: add NDP offload
 capability advertisement
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
 <20261014103359.1508345-10-shivani.baranwal@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261014103359.1508345-10-shivani.baranwal@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA2NyBTYWx0ZWRfXzgZyAKh/XZa2
 5gE1WFTMh0D5qza8UmLjp74RhWUZc9sQlV7kt1JADkQ+41VYQ2bMcGZD+QTSS66YL8ZzmVTj9zb
 Zs1LcAyFn4tuqnqsfz7vdl0eZBeZS2c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA2NyBTYWx0ZWRfX8TJo0e6ErFSg
 7Jc8bMFo31CnXaQflisI4F2buv3cXRh+8USPXMCEV3416p1KW9WMb5dFy1zlklrHDoKk3iYDjRE
 chYmFHoIeO3fki7Uex6aKA41/gCV2UlKv7uaAeQ/fozT0vOKF6sSWSw6uqNbJXVH4Eo+5PIDMcq
 f4PiX7jK55OB+lSbK226g+l6hgHZW7E0Gla78MEkyZtvkWAc1sllKA/sXX2y7mqTrNtzEoNPonb
 Dqh0iP2X2fzgOQnPQrscJMcTIXmWXPvZpcDIDtNV65LaKvr+3jZfZROZI0Whbmv+Pr8hkMYPTlx
 20NsGidztzYyIWYvXy1k1iyfwbjCQJaDkn1vcRg3SB/ueUtrfcxikQAr0fSOihUWYfF514GkBMY
 ajQ02+/7mDqsLUtbKeJbZIcox6PB3gzjFfSzLo9cqF+P0+lM697QXtlNfmHV7L8q5We34Jx0pE3
 qsc/xvR3pyzfR7p1shg==
X-Proofpoint-ORIG-GUID: jQprRg6r7Yo7KUa6P818wgkRT-MFA0uY
X-Proofpoint-GUID: jQprRg6r7Yo7KUa6P818wgkRT-MFA0uY
X-Authority-Analysis: v=2.4 cv=HYSB3SE8 c=1 sm=1 tr=0 ts=6ae37d43 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=_fi4EW-aUu88GZsjmeMA:9 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 adultscore=0 suspectscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290067

On 10/14/2026 3:33 AM, Shivani Baranwal wrote:
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index af2b3a12572e..05ab24b10bf9 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -9279,6 +9279,9 @@ enum nl80211_s1g_short_beacon_attrs {
>   * @NL80211_NAN_CAPA_OFFLOAD_RANGING: flag attribute. Firmware supports the
>   *	fully offloaded NAN ranging procedure, including ranging session setup,
>   *	update, and termination, FTM protocol and procedure, and ranging reports.
> + * @NL80211_NAN_CAPA_OFFLOAD_NDP: flag attribute. Driver handles NAN Data
> + *	Path (NDP) handshake frames and data path key installation.
> +

this blank line results in kernel-doc throwing:
Warning: include/uapi/linux/nl80211.h:9419 bad line:

delete it

>   * @__NL80211_NAN_CAPABILITIES_LAST: Internal
>   * @NL80211_NAN_CAPABILITIES_MAX: Highest NAN capability attribute.
>   */

