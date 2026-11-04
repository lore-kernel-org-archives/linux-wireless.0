Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793769894;
	b=WmD3IMUJTVRV2mUzU/GwMonRNdg1dN76PpFCFXFyYRoAJGElaE6CX+fYF8lD4dYY2mNA
	 yjVf3ElBFHaJiUCqdL0mFhKIzT7hoFlJPEDa4RAFlK7ea4GVF85kGArggcgYdoDaIpy03
	 0A77Oq+bTCciFh7IA+b0O9YS9Q534KWVCK/Kb3Kgg32f/fATskXz92WI8fYMFKzrK6ehX
	 wvHLLWN47S/lJHO6m9eOu76FhfpXwwYEfzEQeLd2lYh11Jmp05A3/l0PHp/y58dpcjEvQ
	 53CJlG/jMHnioOUoF1vtWRL3FZR+3FvICvEZm+PFPkXyGGKApYgIBv/KHAxrFgHGGaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793769894;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=md33AtIgZOxHAVQuAff3BEQKn+9xIRB1oN4Tai/9XIU=;
	b=2Hf+S/ER+56ogKD+K+mBt9/qS1dx4wTLdZrvJCUk+t3stHIzTf/aF/B8+7SQ8Mz2waI5
	 SJkTeQ7mI4/+Ah/sFyU1RY6vwVrMA+Z5N4DtbQjm9B8V/M+caeu6F7Yjw1ZibL5Spopez
	 Z0Vvz/6Bz92IDiogNtkVZhGU2qzS+iVHp9Cs9k5+yFYKVN/e7fjITxO723YTH5FFWy2wR
	 oIso7FOcYzfsQTt9YGMeFP9AoB+xVGehb2sKFr6dx15k+j8cbeD2goGMENd6NW6bwcNwM
	 j7J9tPoxtaPdT1/8a8nLLldI94juEeDyiU72XCGXEA9zIPKFEUk7vgKDIBitJJjZBDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=NmCn6UWJ;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZhMNErrB;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79778606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 05:24:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79778606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=NmCn6UWJ;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZhMNErrB
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40ROfU809361
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 05:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	md33AtIgZOxHAVQuAff3BEQKn+9xIRB1oN4Tai/9XIU=; b=NmCn6UWJ5QAd9kRO
	+GbeO0V7OSTI7SKfo6+flMchUAmW707AK0yGXc/uos+YvcgSlsSwujZyXcE6lrWC
	erctnUUDFeddim+o3y1WNcwxgZHg+q2aH1d2jQzJgpH9vSniBoebjv2GQQwptU7O
	1sC22sn6BUFL8gGMIszQ2NgC680MEnVs/TQJK7LTj775zKN8GyIB5Uew8EuGDtR4
	VqmPMLwYw+/XCpr2gVxXI6bpM9ekQk28ECwYxuunUMq6bO+zmXB8UbzpJmHY1Wrg
	4mGO9uGqxVt1164WWqFbWQy810aawBD5VB4EwuiCafB94UmZXtaM924UIHBbm88r
	ly/A1A==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqkgpaqe2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 05:24:52 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1a2af4c8cbaso229293c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 21:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793769891; x=1794374691; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=md33AtIgZOxHAVQuAff3BEQKn+9xIRB1oN4Tai/9XIU=;
        b=ZhMNErrB/W1c2DncWGSr8Pxneo+BjV12AU5uLsOASBE4hsOS3urmRtKmpMTG4C5Tl7
         p9iHd6CcXGoH4ayQVN8FTp+CONquhfJLhiJQPNKVALwUjOJCr4zWOk5XmU7xP/MXe0vO
         JZRzkkyyb6drUMMqQPWHYKScC8zqlZyUgTfg66G7KmWNEhEW1idUqhHbrCiFGeVV+BbX
         QKtUP62spnmYZa144t0/UH9q4hju+noDmdAgzV3+Uk06hUXxrYb8E0BznOftK6XBOKh3
         YXRVGw9okx9yiZ1eDVd4Ervf0BI5FsUeHulLh0+gvGLNYqRypoWZJSdLcigNCFGJcig9
         lLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793769891; x=1794374691;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=md33AtIgZOxHAVQuAff3BEQKn+9xIRB1oN4Tai/9XIU=;
        b=rnSbQMnAUgxQUXXhDmfTa4mczSvSA1Gq59XBj4UCbIgRVssAlqa9Lz5pSBl+xyZ5ul
         ESSccQv6G8e22HT1LhVu9IW0Cap3WKbv9xdcqViDdpo1tWP6xKxngcAqsc6YtNIW/H+e
         2+smf0nPAFzvfTtHqLdcdbqWjhOEQBlks/CfmUrUPRHFGdbubi1no9Rqr+3yHF5VtWHk
         FepXUKDFbjNo1nLD4JKUvLA7/EFeC/4JA/qT33SjJfKgt1qNvV8FmRECn6xfPB+07y6K
         +VvWOaQ41ybbgocbWPY58wT+5GA1OtPFWN0g8/c4VaSVNjsudBicqjCYXB/fnqksAyKj
         +/aA==
X-Forwarded-Encrypted: i=1; AKwUvBwwRSAELf8qNpbocfWdSbAqCNjPLxm3WFI4EznZXojyuspZO/aOax2Nv24ben3ydEY5t1JE9Vsit8ffFBtEnQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z8hiTK1gzB6M5u5XXt02hVzOnWBn6uUy0RTg7nQoKHqEOMtJ7O9
	CXwUadEzgJ/dljK/5YngTJLDZWTyzRF9jq0HQNGjXHOJMTAh5kOjZGEEBePFaBaigykAZhv+cuV
	a1Z/7NYcRhjyRPek64ALerg4FPPrRUkHi0myQVZdhPIxUCBCpNpQkOj2FANw9kUeS7k9YEA==
X-Gm-Gg: AYBFou2uWwmwnfe+5Z4hfXvG25WTDlPE0JNYF3te2u3tC1709lwyF+Zk3vEzUdszI1k
	ofHf6G/jigARg0AK3ZyGdS9NBMiYuGGTl/8xVQgIWu1msurP3DsVcZ0nATL9rzraGcMDPT/2Cf/
	68kMDqBZw74hjnZw602xZiisRFsDF0t+w/h7LUxWoHS9f7hOGlIJA+9/piRaWM6t/12GUqLCdFp
	sh7nGg7AjZNP5TTCcld1nmmvPbzieTLbHe1IygJusurogdZ6P+TZ9kGvdEc+hAAZcIJp1A6hgtK
	xHVr1581mlJjiqN1h9HlKXu8k0Txf66IRAC81/uq+JlljUhmfc+7otF/11Kzfb6ig17wkpDTMyz
	xhNhbvPqx7SgsDgp6rM5QbxYgM4zuZGCLXcLi9DGy+RIiitPYMyodFB9uQcFZ54UcFtHJWV5Uof
	oZ+dKomXxS/WY1tA/Wj8pbgcsfBCF1HgPbvIugNAztQbfa2zbDOUA+elrlqxyYRklt1L9ywhaOc
	3w=
X-Received: by 2002:a05:701b:2059:10b0:1a3:87c8:7efc with SMTP id a92af1059eb24-1ac5cb186e4mr23305632c88.39.1793769891087;
        Tue, 03 Nov 2026 21:24:51 -0800 (PST)
X-Received: by 2002:a05:701b:2059:10b0:1a3:87c8:7efc with SMTP id a92af1059eb24-1ac5cb186e4mr23305596c88.39.1793769890221;
        Tue, 03 Nov 2026 21:24:50 -0800 (PST)
Received: from [10.149.108.218] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c127sm4387310c88.6.2026.11.03.21.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 21:24:49 -0800 (PST)
Message-ID: <aa665b5f-a3a9-4aeb-ade4-b9b8f04952b3@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 10:54:45 +0530
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
Subject: Re: [PATCH] wifi: ath12k: skip hardware rfkill setup on Surface
 Laptop 8th Edition
To: kernel test robot <lkp@intel.com>, jjohnson@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        sibi.sankar@oss.qualcomm.com
References: <20261103094024.1764151-1-gopikrishna.garmidi@oss.qualcomm.com>
 <202611040318.qlss0Yol-lkp@intel.com>
Content-Language: en-US
From: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
In-Reply-To: <202611040318.qlss0Yol-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMSBTYWx0ZWRfX7JMYofzwz/In
 LoJHzSuhZHJUwtjp7JcQp6hluWXggT2h5XvCKQYRBzg8GkD8fiydPn3sMCp1otKHnYW0yNW7g2e
 NMmaXaFDIcKPRxlbXzcHbD8oMLANQj1Uo9yixqQIzTggVn4bqvrqytvScuqUSBnAYhi1DWo9uR3
 NhLAfGhVU/fdv1ET4o/eLEXZiCGa+P5iP/Tjo+DZaWXuAUOdoVlO7fzzG4+yPAykdLIrjFVICp3
 bETFysj4NHJHAaOBhwSMw/j147rq+uWp2VqF2nWkbhuj5ISEp+3awwfbfyIDjrBGati2A2LVve0
 R3Mr33qxbRXhNmdC8Q9uW1hzQYlOaMqD0kb+SUtyc4rbSiyj/iaNgYAooG/HhHnAkvTh5guzgBQ
 IJUvabV9bLNFLPZDUdc4xNeVl3Ecm2GQX2kTgt9g55zkdxUctxlQZfjymsFe4kCl+7i5TnSz4av
 FUbBe0/9+d8EYkHDXGA==
X-Proofpoint-GUID: nMOKj27Jqy3IpV7pQ6ZXiHqEg5M6FF4s
X-Authority-Analysis: v=2.4 cv=Yoya1IYX c=1 sm=1 tr=0 ts=6aeac1a4 cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=sEU2oqu8ip_TAauk1soA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=vBUdepa8ALXHeOFLBtFW:22 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMSBTYWx0ZWRfX1/3l/8jZX4Uv
 Yvyh6EthXE+SHVmW3qY9aqTMXol8C3Is+RQBAs9nMJKre6Lc6p0vmJH4l9rL3ZXj1biViSnJ4v8
 /bz0pTtWpqpYqIHc9j3Kl3CT2oz6rKI=
X-Proofpoint-ORIG-GUID: nMOKj27Jqy3IpV7pQ6ZXiHqEg5M6FF4s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 spamscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040021



On 11/4/2026 1:18 AM, kernel test robot wrote:
> Hi Gopikrishna,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on ath/ath-next]
> [also build test ERROR on wireless-next/main linus/master next-20261030]
> [cannot apply to wireless/main v7.3]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Gopikrishna-Garmidi/wifi-ath12k-skip-hardware-rfkill-setup-on-Surface-Laptop-8th-Edition/20261103-014024
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git ath-next
> patch link:    https://lore.kernel.org/r/20261103094024.1764151-1-gopikrishna.garmidi%40oss.qualcomm.com
> patch subject: [PATCH] wifi: ath12k: skip hardware rfkill setup on Surface Laptop 8th Edition
> config: arm64-defconfig (https://download.01.org/0day-ci/archive/20261104/202611040318.qlss0Yol-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 16.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261104/202611040318.qlss0Yol-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202611040318.qlss0Yol-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>>> drivers/net/wireless/ath/ath12k/core.c:91:9: error: expected '}' before '{' token
>        91 |         { /* Sentinel */ }
>           |         ^
>     drivers/net/wireless/ath/ath12k/core.c:86:39: note: to match this '{'
>        86 | } ath12k_core_broken_rfkill_table[] = {
>           |                                       ^
> 
> 
> vim +91 drivers/net/wireless/ath/ath12k/core.c
> 
> defae535dd63b1 Aaradhana Sahu      2025-07-08  76
> 5949d1910f13c2 François Roux       2026-10-06  77  /*
> 5949d1910f13c2 François Roux       2026-10-06  78   * On these machines the OS cannot control the WCN7850 hardware rfkill
> 5949d1910f13c2 François Roux       2026-10-06  79   * input, which reads as "radio off", so hardware rfkill must stay
> 5949d1910f13c2 François Roux       2026-10-06  80   * disabled. Ideally this would come from the connector node of the board
> 5949d1910f13c2 François Roux       2026-10-06  81   * DT, but that binding does not exist yet.
> 5949d1910f13c2 François Roux       2026-10-06  82   */
> 5949d1910f13c2 François Roux       2026-10-06  83  static const struct ath12k_core_broken_rfkill_table {
> 5949d1910f13c2 François Roux       2026-10-06  84  	enum ath12k_hw_rev hw_rev;
> 5949d1910f13c2 François Roux       2026-10-06  85  	const char *compatible;
> 5949d1910f13c2 François Roux       2026-10-06  86  } ath12k_core_broken_rfkill_table[] = {
> 5949d1910f13c2 François Roux       2026-10-06  87  	{ ATH12K_HW_WCN7850_HW20, "microsoft,denali" },
> 5949d1910f13c2 François Roux       2026-10-06  88  	{ ATH12K_HW_WCN7850_HW20, "microsoft,romulus13" },
> 5949d1910f13c2 François Roux       2026-10-06  89  	{ ATH12K_HW_WCN7850_HW20, "microsoft,romulus15" },
> 2d169d089ae8e1 Gopikrishna Garmidi 2026-11-03  90  	{ ATH12K_HW_WCN7850_HW20, "microsoft,surface-laptop-8-13p8" }
> 5949d1910f13c2 François Roux       2026-10-06 @91  	{ /* Sentinel */ }
> 5949d1910f13c2 François Roux       2026-10-06  92  };
> 5949d1910f13c2 François Roux       2026-10-06  93
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Thanks, fixed in v2: 
https://lore.kernel.org/all/20261104051838.2912931-1-gopikrishna.garmidi@oss.qualcomm.com/

Thanks,
Gopikrishna

