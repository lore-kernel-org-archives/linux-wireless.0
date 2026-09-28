Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32053CD8B5;
	Mon, 28 Sep 2026 10:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790592328; cv=none; b=S6Z432y0YccrPLLG9CS16fNbB825+kuL+MfWLhGha9wXAR9eHIHM24S1ykcUzZ1FyPugiqaDMMphv7CIXLV+G8nEeOlyd1NwaqbsD07Yc8pzs5LPl4/LiqTxB45GJWWbZvLc4N6M3cz1etJUXqmv7duuXwfIPYd725QHPLOK/io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790592328; c=relaxed/simple;
	bh=w2ef0agF0sHQkwBDp0BYT4U4xIc77QOB1sQFwCzchVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U7KUFYVZ51uf0c52CDXTC+p0AdZ4Wps2eI+sVvQf1Ha3Mf1Tx61SwcJNGrYmaoq4/V3aM6UT9dwBvKMT0i4YGxGd3uHAW2UGceDBE+jpPGje1vuK8Tg0BNUy0mGhuhH2eDzJUYfZEvq4oaxRgupD1HPJF2WiNf+DLzXe8d/aZnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcETg5sc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcETg5sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21241F000FF;
	Mon, 28 Sep 2026 10:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790592326;
	bh=NoKY/U6enyTSm0edyajLicLyKE2psUwChbv2rX46JIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FcETg5scXRjbB85Pp4+fwFvgGfz1+e8xCujtQd2/8VgOzcSvK5LQ9zI7LaEqaAbO7
	 h6z5Q9TsdYsvunK8TG3GodLtnubxHGmd8jogqt1lsu2I2AHCBPm2+xLzpRbyDLgWQR
	 z3pvtS1UzdMnIGeZg6gYDbqUC6ETnBqWfcSwPAhxITOSaiyAEJVbieU3oYopujxyEg
	 3ZHoRDJFm02QzkX8fQEdv1FgVXxFYQvDp4sScXEVepG9Pm1l6g0EE0EL4xAq6h+Tex
	 3DLHVPRbPRQGdgpTqC3W3pCX/3UP15hX91zhlPkFOKcFA/OJaH+I3FAoG7twomFivX
	 DWAATT216k5vQ==
Date: Mon, 28 Sep 2026 12:45:22 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: George Moussalem <george.moussalem@outlook.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, ath11k@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com>, 
	Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH ath-next 02/16] dt-bindings: net: wireless: ath11k: Add
 bindings for IPQ5018
Message-ID: <20260928-sloppy-perfect-marmoset-bfec90@quoll>
References: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
 <20260923-ipq5018-qcn6122-mpd-v1-2-86729521a75c@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260923-ipq5018-qcn6122-mpd-v1-2-86729521a75c@outlook.com>

On Wed, Sep 23, 2026 at 04:05:08PM +0400, George Moussalem wrote:
> Although support was added for IPQ5018, the bindings are missing, so
> let's add them.

So there is no ipq5018 compatible in existing file.

> 
> WiFi on IPQ5018 boards come in one of the following configurations:
> 1. IPQ5018 (standalone) + optional 5G/6G WiFi card (such as QCN9074)
> 2. IPQ5018 (MPD) + one or two 5G/6G QCN6122 WiFi chips where QCN6122
>    is an IPQ5018-specific companion chip.
> 
> IPQ5018 implements the multi-PD architecture as follows:
> 
>                      +-----------------------------+
>                      |     Q6 Remote Processor     |
>                      |            RootPD           |
>                      +--------------+--------------+
>                                     |
>                                     |
>                                     |
>               +---------------------+---------------------+
>               |                     |                     |
>         +-----v-----+         +-----v-----+         +-----v-----+
>         |  UserPD1  |         |  UserPD2  |         |  UserPD3  |
>         |  IPQ5018  |         | QCN6122 #1|         | QCN6122 #2|
>         |  (Radio)  |         |  (Radio)  |         |  (Radio)  |
>         +-----------+         +-----------+         +-----------+
> 
> The rootPD is responsible for managing the lifecycle of the UserPD and
> shared resources and providing SSR notifiers. There are different
> firmware blobs that include either the rootPD and userPD binaries for
> IPQ5018-only which auto-spawns the userPD for IPQ5018 WiFi, or for
> IPQ5018 and QCN6122 for which the userPDs for each radio must be spawned
> by the ath11k driver.
> 
> SMP2P is used for signaling between the host and the Q6 remote processor
> to manage the lifecycle of the userPDs, so add the required interrupts
> and smem-states for incoming and outgoing interrupts in the case of the
> IPQ5018 + QCN6122 MPD configuration. Otherwise, the SMP2P interrupts and
> smem-states are not required for the IPQ5018-only configuration.
> 
> In addition, document the memory regions needed for loading the BDF and
> M3 firmware as well as for assigning the M3 dump memory block.
> 
> Signed-off-by: George Moussalem <george.moussalem@outlook.com>
> ---
>  .../bindings/net/wireless/qcom,ath11k.yaml         | 423 ++++++++++++++++++++-
>  1 file changed, 410 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> index a846cd704b19..621ad6d4ddad 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml

Where is the compatible update?

> @@ -29,8 +29,13 @@ properties:
>      minItems: 32
>      maxItems: 52

56

>  
> +  interrupts-extended:

git grep should tell you - it's not needed. Drop.

> +    minItems: 56
> +    maxItems: 56
> +
>    interrupt-names:
> -    maxItems: 52
> +    minItems: 32
> +    maxItems: 56
>  
>    qcom,rproc:
>      $ref: /schemas/types.yaml#/definitions/phandle
> @@ -56,11 +61,15 @@ properties:
>  
>    memory-region:
>      minItems: 1
> -    maxItems: 2
> +    maxItems: 3
>      description:
>        phandle to a node describing reserved memory (System RAM memory)
>        used by ath11k firmware (see bindings/reserved-memory/reserved-memory.txt)
>  
> +  memory-region-names:
> +    minItems: 1
> +    maxItems: 3

Names would have to be here. But why do you need it in the first place?

> +
>    iommus:
>      minItems: 1
>      maxItems: 2
> @@ -78,20 +87,11 @@ properties:
>    qcom,smem-states:
>      $ref: /schemas/types.yaml#/definitions/phandle-array
>      description: State bits used by the AP to signal the WLAN Q6.
> -    items:
> -      - description: Signal bits used to enable/disable low power mode
> -          on WCN6750 in the case of WoW (Wake on Wireless).
> -        items:
> -          - description: Phandle to the Shared Memory Point 2 Point device
> -              handling the communication with a remote processor
> -          - description: Single bit index to toggle in the value sent to
> -              the remote processor
> -            maximum: 32
> +    minItems: 1
> +    maxItems: 3
>  
>    qcom,smem-state-names:
>      description: The names of the state bits used for SMP2P output.
> -    items:
> -      - const: wlan-smp2p-out

Why isn't all this in qcom,ipq5332-wifi.yaml?

>  
>  required:
>    - compatible
> @@ -103,6 +103,242 @@ additionalProperties: false
>  
>  allOf:
>    - $ref: ieee80211.yaml#
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,ipq5018-wifi
> +    then:
> +      properties:
> +        interrupts:
> +          items:
> +            - description: misc-pulse1 interrupt events
> +            - description: misc-latch interrupt events
> +            - description: sw exception interrupt events
> +            - description: watchdog interrupt events
> +            - description: interrupt event for ring CE0
> +            - description: interrupt event for ring CE1
> +            - description: interrupt event for ring CE2
> +            - description: interrupt event for ring CE3
> +            - description: interrupt event for ring CE4
> +            - description: interrupt event for ring CE5
> +            - description: interrupt event for ring CE6
> +            - description: interrupt event for ring CE7
> +            - description: interrupt event for ring CE8
> +            - description: interrupt event for ring CE9
> +            - description: interrupt event for ring CE10
> +            - description: interrupt event for ring CE11
> +            - description: interrupt event for ring host2wbm-desc-feed
> +            - description: interrupt event for ring host2reo-re-injection
> +            - description: interrupt event for ring host2reo-command
> +            - description: interrupt event for ring host2rxdma-monitor-ring3
> +            - description: interrupt event for ring host2rxdma-monitor-ring2
> +            - description: interrupt event for ring host2rxdma-monitor-ring1
> +            - description: interrupt event for ring reo2ost-exception
> +            - description: interrupt event for ring wbm2host-rx-release
> +            - description: interrupt event for ring reo2host-status
> +            - description: interrupt event for ring reo2host-destination-ring4
> +            - description: interrupt event for ring reo2host-destination-ring3
> +            - description: interrupt event for ring reo2host-destination-ring2
> +            - description: interrupt event for ring reo2host-destination-ring1
> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac3
> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac2
> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac1
> +            - description: interrupt event for ring ppdu-end-interrupts-mac3
> +            - description: interrupt event for ring ppdu-end-interrupts-mac2
> +            - description: interrupt event for ring ppdu-end-interrupts-mac1
> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac3
> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac2
> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac1
> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac3
> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac2
> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac1
> +            - description: interrupt event for ring rxdma2host-destination-ring-mac3
> +            - description: interrupt event for ring rxdma2host-destination-ring-mac2
> +            - description: interrupt event for ring rxdma2host-destination-ring-mac1
> +            - description: interrupt event for ring host2tcl-input-ring4
> +            - description: interrupt event for ring host2tcl-input-ring3
> +            - description: interrupt event for ring host2tcl-input-ring2
> +            - description: interrupt event for ring host2tcl-input-ring1
> +            - description: interrupt event for ring wbm2host-tx-completions-ring3
> +            - description: interrupt event for ring wbm2host-tx-completions-ring2
> +            - description: interrupt event for ring wbm2host-tx-completions-ring1
> +            - description: interrupt event for ring tcl2host-status-ring
> +        interrupts-extended:
> +          items:
> +            - description: misc-pulse1 interrupt events
> +            - description: misc-latch interrupt events
> +            - description: sw exception interrupt events
> +            - description: watchdog interrupt events
> +            - description: interrupt event for ring CE0
> +            - description: interrupt event for ring CE1
> +            - description: interrupt event for ring CE2
> +            - description: interrupt event for ring CE3
> +            - description: interrupt event for ring CE4
> +            - description: interrupt event for ring CE5
> +            - description: interrupt event for ring CE6
> +            - description: interrupt event for ring CE7
> +            - description: interrupt event for ring CE8
> +            - description: interrupt event for ring CE9
> +            - description: interrupt event for ring CE10
> +            - description: interrupt event for ring CE11
> +            - description: interrupt event for ring host2wbm-desc-feed
> +            - description: interrupt event for ring host2reo-re-injection
> +            - description: interrupt event for ring host2reo-command
> +            - description: interrupt event for ring host2rxdma-monitor-ring3
> +            - description: interrupt event for ring host2rxdma-monitor-ring2
> +            - description: interrupt event for ring host2rxdma-monitor-ring1
> +            - description: interrupt event for ring reo2ost-exception
> +            - description: interrupt event for ring wbm2host-rx-release
> +            - description: interrupt event for ring reo2host-status
> +            - description: interrupt event for ring reo2host-destination-ring4
> +            - description: interrupt event for ring reo2host-destination-ring3
> +            - description: interrupt event for ring reo2host-destination-ring2
> +            - description: interrupt event for ring reo2host-destination-ring1
> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac3
> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac2
> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac1
> +            - description: interrupt event for ring ppdu-end-interrupts-mac3
> +            - description: interrupt event for ring ppdu-end-interrupts-mac2
> +            - description: interrupt event for ring ppdu-end-interrupts-mac1
> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac3
> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac2
> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac1
> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac3
> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac2
> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac1
> +            - description: interrupt event for ring rxdma2host-destination-ring-mac3
> +            - description: interrupt event for ring rxdma2host-destination-ring-mac2
> +            - description: interrupt event for ring rxdma2host-destination-ring-mac1
> +            - description: interrupt event for ring host2tcl-input-ring4
> +            - description: interrupt event for ring host2tcl-input-ring3
> +            - description: interrupt event for ring host2tcl-input-ring2
> +            - description: interrupt event for ring host2tcl-input-ring1
> +            - description: interrupt event for ring wbm2host-tx-completions-ring3
> +            - description: interrupt event for ring wbm2host-tx-completions-ring2
> +            - description: interrupt event for ring wbm2host-tx-completions-ring1
> +            - description: interrupt event for ring tcl2host-status-ring
> +            - description: Q6 firmware user PD fatal interrupt event
> +            - description: Q6 firmware user PD ready interrupt event
> +            - description: Q6 firmware user PD spawn interrupt event
> +            - description: Q6 firmware user PD stop ack interrupt event
> +        interrupt-names:
> +          minItems: 52
> +          items:
> +            - const: misc-pulse1
> +            - const: misc-latch
> +            - const: sw-exception
> +            - const: watchdog
> +            - const: ce0
> +            - const: ce1
> +            - const: ce2
> +            - const: ce3
> +            - const: ce4
> +            - const: ce5
> +            - const: ce6
> +            - const: ce7
> +            - const: ce8
> +            - const: ce9
> +            - const: ce10
> +            - const: ce11
> +            - const: host2wbm-desc-feed
> +            - const: host2reo-re-injection
> +            - const: host2reo-command
> +            - const: host2rxdma-monitor-ring3
> +            - const: host2rxdma-monitor-ring2
> +            - const: host2rxdma-monitor-ring1
> +            - const: reo2ost-exception
> +            - const: wbm2host-rx-release
> +            - const: reo2host-status
> +            - const: reo2host-destination-ring4
> +            - const: reo2host-destination-ring3
> +            - const: reo2host-destination-ring2
> +            - const: reo2host-destination-ring1
> +            - const: rxdma2host-monitor-destination-mac3
> +            - const: rxdma2host-monitor-destination-mac2
> +            - const: rxdma2host-monitor-destination-mac1
> +            - const: ppdu-end-interrupts-mac3
> +            - const: ppdu-end-interrupts-mac2
> +            - const: ppdu-end-interrupts-mac1
> +            - const: rxdma2host-monitor-status-ring-mac3
> +            - const: rxdma2host-monitor-status-ring-mac2
> +            - const: rxdma2host-monitor-status-ring-mac1
> +            - const: host2rxdma-host-buf-ring-mac3
> +            - const: host2rxdma-host-buf-ring-mac2
> +            - const: host2rxdma-host-buf-ring-mac1
> +            - const: rxdma2host-destination-ring-mac3
> +            - const: rxdma2host-destination-ring-mac2
> +            - const: rxdma2host-destination-ring-mac1
> +            - const: host2tcl-input-ring4
> +            - const: host2tcl-input-ring3
> +            - const: host2tcl-input-ring2
> +            - const: host2tcl-input-ring1
> +            - const: wbm2host-tx-completions-ring3
> +            - const: wbm2host-tx-completions-ring2
> +            - const: wbm2host-tx-completions-ring1
> +            - const: tcl2host-status-ring
> +            - const: fatal
> +            - const: ready
> +            - const: spawn
> +            - const: stop-ack
> +        memory-region:
> +          items:
> +            - description: memory region for Q6 firmware
> +            - description: memory region for M3 firmware
> +            - description: memory region for M3 dump
> +        memory-region-names:
> +          items:
> +            - const: q6-region
> +            - const: m3-region
> +            - const: m3-dump
> +        qcom,smem-states:
> +          items:
> +            - description: Signal bit used to shutdown Q6 user PD
> +              items:
> +                - description: Phandle to the Shared Memory Point 2 Point device
> +                - description: Single bit index to toggle in the value sent to the remote processor
> +                  maximum: 32
> +            - description: Signal bit used to stop Q6 user PD
> +              items:
> +                - description: Phandle to the Shared Memory Point 2 Point device
> +                - description: Single bit index to toggle in the value sent to the remote processor
> +                  maximum: 32
> +            - description: Signal bit used to spawn Q6 user PD
> +              items:
> +                - description: Phandle to the Shared Memory Point 2 Point device
> +                - description: Single bit index to toggle in the value sent to the remote processor
> +                  maximum: 32
> +        qcom,smem-state-names:
> +          items:
> +            - const: shutdown
> +            - const: stop
> +            - const: spawn
> +      allOf:
> +        - anyOf:
> +            - required:
> +                - interrupts
> +            - required:
> +                - interrupts-extended
> +        - if:
> +            required:
> +              - interrupts-extended
> +          then:
> +            properties:
> +              interrupt-names:
> +                minItems: 56
> +            required:
> +              - interrupts-extended
> +              - memory-region
> +              - memory-region-names
> +              - qcom,smem-states
> +              - qcom,smem-state-names
> +          else:
> +            properties:
> +              interrupt-names:
> +                minItems: 52
> +                maxItems: 52
> +
>    - if:
>        properties:
>          compatible:
> @@ -265,6 +501,19 @@ allOf:
>              - description: interrupt event for ring DP20
>              - description: interrupt event for ring DP21
>              - description: interrupt event for ring DP22
> +        qcom,smem-states:
> +          items:
> +            - description: Signal bits used to enable/disable low power mode
> +                on WCN6750 in the case of WoW (Wake on Wireless).
> +              items:
> +                - description: Phandle to the Shared Memory Point 2 Point device
> +                    handling the communication with a remote processor
> +                - description: Single bit index to toggle in the value sent to
> +                    the remote processor
> +                  maximum: 32
> +        qcom,smem-state-names:
> +          items:
> +            - const: wlan-smp2p-out
>  
>  examples:
>    - |
> @@ -464,3 +713,151 @@ examples:
>              iommus = <&apps_smmu 0x1c02 0x1>;
>          };
>      };
> +
> +  - |

No, three examples are enough. No need for fourth.

Best regards,
Krzysztof

