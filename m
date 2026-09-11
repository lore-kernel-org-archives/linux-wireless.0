Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385F3408026;
	Fri, 11 Sep 2026 07:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111016; cv=none; b=XJKfELRWMtJFqTGqiRopjS2IC7dekC2puZk/v7PYAK6Z9aBrYibSeKaxuhLZ26kZb9/pAys+Ye8CQEfhuVlaS0rupVo1SgKXpS3jnC1drVhR0w2D2rhXOP+n+ZjWrNy17CLNF59m00zRV+50J6UfyUgyEsaO8fhi1NcBa1lyu/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111016; c=relaxed/simple;
	bh=9fMYtrX1EvVkrIp+f45k4OUe+00uEnhfE/7SQPpX67I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SdSRgX9MSO9L68PUM51CmQ2J7axZnPVoIXpCixJGChSCiYlLLyXftepgbLKZXDtgtRn6E08iwuwVeJrhwjobgA9Yj25VGSDPEopuRsKxIJrZohTftbVv4LNkkfA1KZQh8ssZvau5S3cxlEMUXL7vwvV9YhA8HMWri+tGcX8f0CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mA11ete3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mA11ete3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC211F00899;
	Fri, 11 Sep 2026 07:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789111003;
	bh=qi8tO0zS4dwdokctM0TPh12wejUkRjDhNme5BOC8Oqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mA11ete3jDX9cu/85xEzWyiS93JalyG3KB/CPNONW3MXJz3FoVir1JVwk4bQEzAtr
	 Po8ThEwhisG8GzJyk4QXPmfVq9cwy5OxJmVwquuk68tFHc+V0HxeFY79QV0JSzJNLI
	 M1UJN4EdRTC3kR0b7XJv4rWmCZ54hKhXwJkyoExGqyXILS05xsGNz1cWhXslbYbIC8
	 dhLI+pN1jdsyFAhlBseYAVRryFxDq+IYvNa5a1dXoNa+HSMb4CZ2dzneMreOdIVuyb
	 p/I0RSra1v41L/HRFPbqVG5CCwHyT1HrO2aI/IIbFez+hdxKqHZ1ovQfwD7FztX9t6
	 6nXtDT488kxTg==
Date: Fri, 11 Sep 2026 09:16:38 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Eduard Bostina <egbostina@gmail.com>
Cc: Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org, 
	Johannes Berg <johannes@sipsolutions.net>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2] dt-bindings: net: wireless: Convert WL1251 to DT
 schema
Message-ID: <20260911-cordial-camouflaged-marmot-4ca71c@quoll>
References: <20260905201108.415713-1-egbostina@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260905201108.415713-1-egbostina@gmail.com>

On Sat, Sep 05, 2026 at 08:11:08PM +0000, Eduard Bostina wrote:
> +allOf:
> +  - $ref: /schemas/spi/spi-peripheral-props.yaml#
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/gpio/gpio.h>
> +    spi {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        wl1251@0 {

Nodename: wifi

With this fixed:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

