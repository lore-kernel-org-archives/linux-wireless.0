Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34620 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932392AbeGDJvj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 05:51:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 04 Jul 2018 15:21:38 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, Rob Herring <robh+dt@kernel.org>,
        andy.gross@linaro.org
Subject: Re: [PATCH v2 3/6] dt: bindings: add bindings for msa memory region
In-Reply-To: <20180703160122.w54lq7mr2uectjea@lakrids.cambridge.arm.com>
References: <20180605123616.528-1-govinds@codeaurora.org>
 <20180605231814.GB194157@rodete-desktop-imager.corp.google.com>
 <87o9fonx5r.fsf@kamboji.qca.qualcomm.com>
 <20180703160122.w54lq7mr2uectjea@lakrids.cambridge.arm.com>
Message-ID: <efdb902e1fb8e5476a5661dfedc36aba@codeaurora.org> (sfid-20180704_115143_335745_AF760818)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-03 21:31, Mark Rutland wrote:
> On Tue, Jul 03, 2018 at 06:42:24PM +0300, Kalle Valo wrote:
>> Brian Norris <briannorris@chromium.org> writes:
>> 
>> > + Rob
>> >
>> > On Tue, Jun 05, 2018 at 06:06:16PM +0530, Govind Singh wrote:
>> >> Add device tree binding documentation details of msa
>> >> memory region for ath10k qmi client for SDM845/APQ8098
>> >> SoC into "qcom,ath10k.txt".
>> >>
>> >> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> >> ---
>> >>  .../devicetree/bindings/net/wireless/qcom,ath10k.txt          | 4 ++++
>> >>  1 file changed, 4 insertions(+)
>> >>
>> >> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> >> index 7fd4e8ce4149..0efc47f4ba34 100644
>> >> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> >> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> >> @@ -56,6 +56,8 @@ Optional properties:
>> >>  				     the length can vary between hw versions.
>> >>  - <supply-name>-supply: handle to the regulator device tree node
>> >>  			   optional "supply-name" is "vdd-0.8-cx-mx".
>> >> +- msa-fixed-region: phandle, specifier to children of reserved MSA memory.
>> >
>> > As in reserved-memory/reserved-memory.txt? Might refer to that doc here.
>> > Or is this some other kind of reserved memory?
>> >

sure, i will give reference to reserved-memory.txt.

>> > If the former, it's normally called just "memory-region", although
>> > that does seem somewhat non-descriptive...
>> >
>> >> +- msa-size: MSA memory size for fw internal use.
>> >
>> > Do you really need both of these? It seems like your code uses one or
>> > the other, not both. In which case, this is not a very good description,
>> > because it sounds like they would go together.
>> >
>> > Also, if you're not using standard/generic properties (e.g., the
>> > aforementioned "memory-region" binding), you typically should use a
>> > vendor prefix, like "qcom,msa-size".
>> 
>> Devicetree folks, any comments? I would like to apply this via my
>> ath.git tree but need help with the review.
> 
> I think Brian's comments w.r.t msa-size and msa-fixed-region both 
> stand.
> It would be good if Govind could answer his questions.
> 

As Brian suggested, i am planing to remove msa-size and keep only 
msa-fixed-region.


Thanks
Govind
