Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12136 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbbKLOyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 09:54:15 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: Ryan Hsu <ryanhsu@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH v3] ath10k: Override CE5 configuration for QCA6147 device
References: <1447266082-10933-1-git-send-email-ryanhsu@qca.qualcomm.com>
	<CAGRGNgXOPDF1fK6X2b-qiTBOLqh+fcScEDDZAoEWTJLDrXPFuA@mail.gmail.com>
Date: Thu, 12 Nov 2015 16:53:58 +0200
In-Reply-To: <CAGRGNgXOPDF1fK6X2b-qiTBOLqh+fcScEDDZAoEWTJLDrXPFuA@mail.gmail.com>
	(Julian Calaby's message of "Thu, 12 Nov 2015 21:47:28 +1100")
Message-ID: <87d1vf6zg9.fsf@kamboji.qca.qualcomm.com> (sfid-20151112_155418_764550_A8B199C7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

>> +static void ath10k_pci_override_ce_config(struct ath10k *ar)
>> +{
>> +       struct ce_attr *attr;
>> +       struct ce_pipe_config *config;
>> +
>> +       /* For QCA6174 we're overriding the Copy Engine 5 configuration,
>> +        * since it is currently used for other feature.
>> +        */
>> +
>> +       /* Override Host's Copy Engine 5 configuration */
>> +       attr = &host_ce_config_wlan[5];
>> +       attr->src_sz_max = 0;
>> +       attr->dest_nentries = 0;
>> +
>> +       /* Override Target firmware's Copy Engine configuration */
>> +       config = &target_ce_config_wlan[5];
>> +       config->pipedir = __cpu_to_le32(PIPEDIR_OUT);
>> +       config->nbytes_max = __cpu_to_le32(2048);
>> +
>> +       /* Map from service/endpoint to Copy Engine */
>> +       target_service_to_ce_map_wlan[15].pipenum = __cpu_to_le32(1);
>> +}
>> +
>
> Stupid question: Why not have two different versions of each struct?
> One for QCA6174 and one for everyone else, and choose the appropriate
> one when they're uploaded to the firmware / used?

That's duplicate work when you change something in common CEs and
chances of missing something increases.

-- 
Kalle Valo
