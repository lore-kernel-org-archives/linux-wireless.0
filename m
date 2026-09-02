Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA313672BF
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327062; cv=none; b=HHWWjCzXLD3FBbyZLxPmuPbMZAdPtmJBbGAaqJ594a3jknf2bdZKes/NiAOhQigcJqRIAlxUWF305G79wS5f/dlmbSnGsqXn3fM4IZ/eYC0e9m7i1mqm2XQFQfaRivc3oGdeNkpQ762Q/+fbXzFdZp6FXN1zT3ct/Lg4TXPj2pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327062; c=relaxed/simple;
	bh=EErxRj9UamHxjL4qovNFexC2eoDhDkme3XwtJu95u6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rj+hb+goW2NalutXXcQrKnXQLNurGR0kxKpEVzbHhAz1N3fAx5JlXiUlkmRDJE/n/fRlKeBfcA7gn2CsfJevyGqWmfrzJ02HibJ3KL/WdSYYG4h/L1sjq0ZOhbLaUXtVn2qW33NTa+i/krkMloySRT1hKQqgBec9D1xhzVIuv38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c2jPeDiT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cVUiNyW/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c2jPeDiT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cVUiNyW/"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68202PU81013570
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 05:31:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EErxRj9UamHxjL4qovNFexC2eoDhDkme3XwtJu95u6Y=; b=c2jPeDiTCeOUZ+Ms
	LDfvknHx3w8HS4tzLQFo8FeefuE26hYIfDzmCR63ke5HsTrJhVNRJ4izfpXB0ssw
	webIHA/6bABWsLA1p/ztDuFgHvg1mkJXMCDTkhmkQP3IGyj7VCPugPCCD+1Oq7Oe
	GKwl73PE7usS1R0M0BFMgfEmqQwzWrKy2dI0rZbPKedLcZDptd4JdDT+Ap5zr7or
	Xcj9TYijr4hxx1KlLlOSR1iT/240UHSABpzX0lHN4vfOpdyXfvXJSNYZVlnVAgcA
	OQaL+qvn/miYq+lTGRaGVsYnHHepG14/UNsfuRW4Uht9HuVYjLcLQQFZ8OMwvjOS
	GVLutA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ge8whgx2p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 05:31:00 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc12e8e22b7so1609207a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 22:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788327059; x=1788931859; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EErxRj9UamHxjL4qovNFexC2eoDhDkme3XwtJu95u6Y=;
        b=cVUiNyW/ohBB+s7jOsi+qnKDuhoqnsuIqqXC6JiO1+cXdWMuegmxe0TrzVCLnvvhc0
         3tHsxF4IX2c+KjMxnRRUHzHYaUJN252/ubYX0D+7eC8di2GkQc7yjvZu2xPfRFfvGYGy
         cAFCwd/3XKPHmaWs3X9R98gBKLQBjOu6HkNYGRVwlBULfteYKCGl9p0H3hpq0mvzXzhp
         i4C2OOjgMk1UYrSeWqa9eCsItFpd3MyP2Zi8WXc+0E2AqcbhKrZogBZiQo4130PR1HRL
         Dg6gIBTlZ5H8NiVDdww1aWJlRE5D23RVK5VZkkF10at0T93liQCBoDhjDuDdlYLtjG7N
         qCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788327059; x=1788931859;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EErxRj9UamHxjL4qovNFexC2eoDhDkme3XwtJu95u6Y=;
        b=Gljz/zFbePwLawVnkhrVcZVctGtPDUK1NBIMlZrmCv7LYwUCoHg5vNSN1YBuDAUFDv
         hWxkqUbOuN9Yst23cEfhk2Xe7lMjd/iuj1lJpiSaEK6xX2Np1ryRFUTM4BR4Wtk3oKnG
         uXoTcXEPdOwqfqQhWknbnqVVqZMe5DCc5mwgoVeyf9Hdo1tXVQNvtoj2QcDfbleTYm7d
         SV3x56IHpIwlbgyxas1Gn8ruh+Gdt70AcG42u25Mv3EUNSlc4mx/ajNnzuZfH94dCOeb
         E2VR4VvahjeVjeaPkTOIP9S1dnq6kuSIPjAYWL6EcNjT+0u4qLKkxtX8dHvIsIFr8Bkg
         ZzJQ==
X-Forwarded-Encrypted: i=1; AKwUvBzAEqNqXr9jzz7A7T3rc6C+ZQ/rDJA/5dh3StoCLCEVY0FIMxfaKWYve2+NRVFI9Gbtjrnb8LPuzYbd2clEcg==@vger.kernel.org
X-Gm-Message-State: AFuF++lPDep7EG9q/7QKaX82g+fZWoziuQWpgt1TfvKm6S8wd8C+Y2C9
	g+Q+kKnGg4MSx46zTJnm2oQDcmyIR2/jpKKKmJjVdilEM6o/HE13kuNuvvz3sPMTCnRErTwnJ5e
	jhHmQFksYVb4dhlVBlcIsTXZXnYFQWtZk5gGPu7kBoIlRQGD6dakhptmhHQFYGH7r9hl6YQ==
X-Gm-Gg: AYBFou1poSZHxc58ZU6jcoinw/rxJVLG7olFJyQG1wafMeIv7KXDGd/EPcoi40QnFZe
	NPsrC6JU6GqE4YaruKYg3eslEPi872DbEFUGsqQBjgD0LdVFvTVPFQ3EucM/cmEYCX3FvJT4OGh
	udjbYG8knGwbyiXqu9OIJ849RMPq9GpRKeDR65N+hUFTrcxL1cw2mNI4j6S+O5Bo5w7QNv8OLbr
	NeLeIGZqsYlj4Diy/l71Aj9lLqbeN8Dz3wRB4f6iLxQRIvAyQeSUgD22ciHZ7I7eSXqbxIyqndM
	a+MOuzaUvKUEZTITVQYpr4lLdE6vg0TaY73yExs1mbseD4nzblD4aGm5+NsnOs/gCnBBsk7AB0E
	j4yVHrkyl31zPBkJe+zb34ECs42rWOYhS
X-Received: by 2002:a17:90b:1c07:b0:398:d8eb:cb2a with SMTP id 98e67ed59e1d1-39aee260bc0mr2726725a91.23.1788327059338;
        Tue, 01 Sep 2026 22:30:59 -0700 (PDT)
X-Received: by 2002:a17:90b:1c07:b0:398:d8eb:cb2a with SMTP id 98e67ed59e1d1-39aee260bc0mr2726667a91.23.1788327058905;
        Tue, 01 Sep 2026 22:30:58 -0700 (PDT)
Received: from [10.218.35.45] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1430e8c6fcbsm5163942c88.0.2026.09.01.22.30.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 22:30:58 -0700 (PDT)
Message-ID: <774adaa9-55de-4456-9ee2-eb3c5d7ea0a5@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 11:00:51 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/6] wifi: ath11k: Add support for MHI bandwidth
 scaling
To: Neil Armstrong <neil.armstrong@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Lorenzo Pieralisi
 <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Manivannan Sadhasivam <mani@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        qiang.yu@oss.qualcomm.com, Miaoqing Pan <quic_miaoqing@quicinc.com>
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
 <20260819-bwscale-v5-5-6dea79786b37@oss.qualcomm.com>
 <5b10cb13-77e6-4754-a885-92c873866ef4@linaro.org>
Content-Language: en-US
From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
In-Reply-To: <5b10cb13-77e6-4754-a885-92c873866ef4@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=fLkJG5ae c=1 sm=1 tr=0 ts=6a97b494 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=WikkZxfSKXF9q-dYMVUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: yJxPi4rniZ5ZVoQiuvvbA8q5QZpfAou4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA0NiBTYWx0ZWRfXyVTVkFnnqw+m
 0IE/gsx7inivKMyEBxYlD5yYJzkedqia/EhtDHOhHxA6biLSO05cZIL466G8lHTPzXoxoUcy9LX
 jon+3S4ku1rXalh+nUOK1XP8bvZPIjqPymzWvKFETgpKqQMPtu5PzZaRkRpiu5pYPDzYFEB9onn
 42IC4Vr0CoO14Is0NOV8JdKnTRS3/3PVP/6mcKbnW7JGEVp9gpdx1W6b1ALhC5LJ+W1hSoqZUvv
 olbWMhP+xN2GxA6qjcxXd4REJ4doF9Jmsy7LQ6MdjTwQJunSaH5iRigx056X21viNql2LONlkvF
 SJrXYa4Bb9hPHPzbPCpXmPricg/Cy9XjRsNf/KjMbrcGxXSfpoEj/LSJBAbh7K+Ql2MPv3qN1WV
 GdGpyjqSAVHRWq9oADmGZPkbAjgl/cGTCM+NdEURx9wUjreycbsX8HCKmnzvABkd6PreKMxwJzO
 w33JfmfEVSEX6gqdG3g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA0NiBTYWx0ZWRfXw5dFwOkwWox8
 Vc/JA1bVWtG5QnQaA3ZAE8IRjNOD3/ID8f6oQo8N44vnBrlCjv79rzO0LaF8Gq/DSZ56AYVFFUE
 YDfMs9bmZZ5PG1oweYa7bTlpADcjzlU=
X-Proofpoint-GUID: yJxPi4rniZ5ZVoQiuvvbA8q5QZpfAou4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_06,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020046



On 9/1/2026 8:15 PM, Neil Armstrong wrote:
> Hi,
>
> On 8/19/26 15:25, Krishna Chaitanya Chundru wrote:
>> From: Miaoqing Pan <quic_miaoqing@quicinc.com>
>>
>> Add support for MHI bandwidth scaling, which will reduce power consumption
>> if WLAN operates with lower bandwidth. This feature is only enabled for
>> QCA6390.
>>
>> Bandwidth scaling is initiated by the endpoint firmware based upon the
>> bandwidth requirements, if there is high bandwidth data endpoint requests
>> for higher data rates or if there is less bandwidth they request for lower
>> data rates to reduce power. Endpoint initiates this through MHI protocol.
>>
>> Tested-on: WCN6855 hw2.1 PCI
>> WLAN.HSP.1.1-04546-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1
>
> Somehow unrelated, but I added this to the ath12k to test on an WCN785x and
> I just
> got a single event to set the speed to 5GT/s and no further event whatever
> the state
> of the Wireless link is.
>
> Is there anything required on the ath12k side to allow lowering the speed to
> 2.5GT/s ? 
some wifi device has some limitation due to that they will stay in gen2 only.

- Krishna Chaitanya.
>
> Thanks,
> Neil
>
>>
>> Signed-off-by: Miaoqing Pan <quic_miaoqing@quicinc.com>
>> Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath11k/mhi.c | 38
>> +++++++++++++++++++++++++++++++++++
>>   1 file changed, 38 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath11k/mhi.c
>> b/drivers/net/wireless/ath/ath11k/mhi.c
>> index a6c9ff112c68..9bff4c4bca3b 100644
>> --- a/drivers/net/wireless/ath/ath11k/mhi.c
>> +++ b/drivers/net/wireless/ath/ath11k/mhi.c
>> @@ -20,6 +20,7 @@
>>   #define MHI_TIMEOUT_DEFAULT_MS    20000
>>   #define RDDM_DUMP_SIZE    0x420000
>>   #define MHI_CB_INVALID    0xff
>> +#define MHI_BW_SCALE_CHAN_DB 126
>>     static const struct mhi_channel_config ath11k_mhi_channels_qca6390[] = {
>>       {
>> @@ -71,6 +72,17 @@ static struct mhi_event_config
>> ath11k_mhi_events_qca6390[] = {
>>           .client_managed = false,
>>           .offload_channel = false,
>>       },
>> +    {
>> +        .num_elements = 8,
>> +        .irq_moderation_ms = 0,
>> +        .irq = 1,
>> +        .mode = MHI_DB_BRST_DISABLE,
>> +        .data_type = MHI_ER_BW_SCALE,
>> +        .priority = 2,
>> +        .hardware_event = false,
>> +        .client_managed = false,
>> +        .offload_channel = false,
>> +    },
>>   };
>>     static const struct mhi_controller_config ath11k_mhi_config_qca6390 = {
>> @@ -311,6 +323,30 @@ static void ath11k_mhi_op_write_reg(struct
>> mhi_controller *mhi_cntrl,
>>       writel(val, addr);
>>   }
>>   +static int ath11k_mhi_op_get_misc_doorbell(struct mhi_controller
>> *mhi_cntrl,
>> +                       enum mhi_er_data_type type)
>> +{
>> +    if (type == MHI_ER_BW_SCALE)
>> +        return MHI_BW_SCALE_CHAN_DB;
>> +
>> +    return -EOPNOTSUPP;
>> +}
>> +
>> +static int ath11k_mhi_op_bw_scale(struct mhi_controller *mhi_cntrl,
>> +                  struct mhi_link_info *link_info)
>> +{
>> +    enum pci_bus_speed speed =
>> pci_lnkctl2_bus_speed(link_info->target_link_speed);
>> +    struct ath11k_base *ab = dev_get_drvdata(mhi_cntrl->cntrl_dev);
>> +    struct pci_dev *pci_dev = to_pci_dev(ab->dev);
>> +    struct pci_dev *pdev;
>> +
>> +    pdev = pci_upstream_bridge(pci_dev);
>> +    if (!pdev)
>> +        return -ENODEV;
>> +
>> +    return pcie_set_target_speed(pdev, speed, true);
>> +}
>> +
>>   static int ath11k_mhi_read_addr_from_dt(struct mhi_controller *mhi_ctrl)
>>   {
>>       struct device_node *np;
>> @@ -387,6 +423,8 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
>>       mhi_ctrl->status_cb = ath11k_mhi_op_status_cb;
>>       mhi_ctrl->read_reg = ath11k_mhi_op_read_reg;
>>       mhi_ctrl->write_reg = ath11k_mhi_op_write_reg;
>> +    mhi_ctrl->bw_scale = ath11k_mhi_op_bw_scale;
>> +    mhi_ctrl->get_misc_doorbell = ath11k_mhi_op_get_misc_doorbell;
>>         switch (ab->hw_rev) {
>>       case ATH11K_HW_QCN9074_HW10:
>>
>

