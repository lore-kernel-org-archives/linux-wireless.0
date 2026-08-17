Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBC63D6CD7
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 22:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787004884; cv=pass; b=dkXvkEwtmGt4qbbwSynB2svnV+eNYwIuwS+7R89ODMVgOaNofS9Fos+ZMi8v9eslTbFGACFOcd26OY73JXB1vLLkChboX1EmEnr5GbQAxGydsoOrdTH01RNTntfmNLREoYGWct7ImRaeDyq6WOeWGaO5JD90E6zC/Net9+zRwVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787004884; c=relaxed/simple;
	bh=2VWf7wQ8uvu82um+zdpZ78ZohKBiuSNnAFrwI+RA/qI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=icgnELIVbQPP/IqP1f4zok3gbocGdJy6GoJoJPml6+zNcP8CKCnbF7zSsLy+dB31xbJ11UpMJDkZqyJguf7femjY0hm9eCZdHhrmJ+ZQKwwvOv/7RSs/YdZH5uuoTEw0OVCTJr9JAdaZDlO0Ba5U/cK4e614X5ovAFrZ+/D5X6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G/1GpNFm; arc=pass smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G/1GpNFm"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84faf0fa17eso3992093b3a.2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 15:14:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787004883; cv=none;
        d=google.com; s=arc-20260327;
        b=M0yzsWxlbqa+PJMuMUZJnohfj0vF9zpiC1B0B+UvQIZuuF1FCCQjW4CCLwaCkvd/KN
         Le8VRcYeRfWbdbFIF8OdYDhKqmM9FBA6TF5l3L1wlXkH3HvlM4cZq2lPiDLdRb1mDYBv
         Evu9B7JQ2AUGInEyILvbOFre81ngMrDqMAdgojxBB3+e+XUI9+Htc5aV51ez4ftN04hx
         06dDtluWBacvZmtbuPPemywERfTzbvFlZ/HemDmO1dmPqUe5ih0c0O7HHZb0Op9CEOTr
         knHFnEnYeztYI/A45EQnGhoKGHj+TnoyVd+hL98MO+bQ9JkmRihegi6vts3CS36Fi5CT
         eleQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2VWf7wQ8uvu82um+zdpZ78ZohKBiuSNnAFrwI+RA/qI=;
        fh=z9fTGAWyO4azLGe0XG9+cBNC0/OY7dmKpLVzz3Ci2ns=;
        b=MTutJOgSrlI1TXrGrXCMqCgkmbRAZZ7E9/f+SdhjzYszElqwPezvyd5Vh3V3Cht7za
         OeFGj0v8rqJbtHZufn+KZt7oChgZPLO0qsoYv25IBEzIH/+HsTZQX1364UU0/ZyueYv9
         sRVzpzXg9hBckTPu9HAKMRj+pxxeU2aV0gm1jBBcldNPZskvX07szy1k7ifa1oTVlGsL
         vvTGdc5YlxRmvf8A7YtKSPkljwiFOg3UKCqbWbA+cru8y7DDrrRke4iKaLZXcd46eZO6
         sRav0g67cHDDKuShMVSifbt8xckTxnfHtse7Q4Qs7k7s0HfuVXaYUV6KEdqwXKofeDE+
         1Fzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787004883; x=1787609683; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2VWf7wQ8uvu82um+zdpZ78ZohKBiuSNnAFrwI+RA/qI=;
        b=G/1GpNFmnB/uOp0AzMYyn+jddSG7pmnxwkBdhMFVnZta+dz2NTLYSrnEEGgwHRJmss
         JvOYp+PR/z8c5DDiP4r3x9lkNGAfoHRJd77k+nfEOl69rR5h/eaUyay6TU+mAIw4Z1Wr
         z7aYOfZUkcjUJAb3QSgCMLLep8XLIuoQVPp7xA7CX/cxramsWTiorc10Unz3yL08Clpo
         HMsw6X/Ue//bBMeikXG6IsjgqRhZUmTzH0m5HRJBlxKVAm3uLRwYp6Gt7pQXY6TnwwAU
         t4nVc9HtJ3PJeF1FVd1GwB6bjXew1Fkd34YLGe+pZM0P2/kAI/tnxk1pPibF53LqzjW7
         wd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787004883; x=1787609683;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2VWf7wQ8uvu82um+zdpZ78ZohKBiuSNnAFrwI+RA/qI=;
        b=Jumxmtoan4LELrfxdoHCxftRDe3R/3P+yAYJKV4oF1TWR/iKYML1YDQoJv9UDl+PLr
         oDUWSlaNwfoMIAbJww9K/UfGgFqGbhqXgtKZTLLS5fFWKNry2ng/asaJYxZjtPwar6am
         rCqu4XQTHqojDa5iUbuLezzc8qVybA2Rq8E/kk6TVUG5zSEmnSsQCqcec6C9wwvYWPj/
         Z0htpuffVRMFhG04aE42XxUdDPJY0UqcR+gX5Wc7xNRvgQm/UJx2g8AROjX7C6GG4Vqa
         JjTOMhWgqMP0U2bTZArDBwxTGP2650HKb6s58LNz6/tdhKV/I/k9g4zcwnQ2iI+4Zhst
         XYQQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro1DCirDaZ5Lb0fYjLF6aDMGj0O/bbxDf6Q25n7I1c4SiWaCvFfMhA/1q9QFvUAjVAXZsv1vBrKrFENz7hfNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJfIb6eNE4rgq19WX92Gjrtzyv8yZfM1hVfbj20+Qoitcb3ffz
	ruiFh/wDkuWXsl7Z622j/w81bOCgsgujjBnPQsEyAqgp91z0cAPXhfoVmUlIG1rjSRV0GeDnyZh
	nN+bhiJSyire1NtetuTo2V8CNePorxU4=
X-Gm-Gg: AR+sD13WcSw95TgrVFYf9HYHf4iMAaYUFcMJ7H9wAFb5iwj67kanajShWc9UEMmFyfO
	F15mBwjFpiM8FYd2MDh4uJDN9ozI1ADmp5OrAQwiwNnXL2jd3PCsEMMp/crEafxJe00qQ/Ud/Mb
	pwvVUiRGJ6T+ORBJTeGGTXTGKfgdfVTr8LBqoVkjj1Gmd1H2eSYavmNka2Om2/h6HQGZgiUlY0p
	/r9i7vuxrM8YUTJGcju30x2Bvih7il3xk2/vFqJBXrUGHmjfyl6GSwRw6/Lh1Ab+ipUeGfeAOgi
	7847dA9PWyBZxtN3H+i3+QXaKGX+iCzX6FMzZ3DBdLbadrNtjRIDvabq83YModaPooXWooRvYm9
	4YTuSOclTxLtkbw==
X-Received: by 2002:a05:6a20:3d1a:b0:3c3:875d:c52f with SMTP id
 adf61e73a8af0-3cc71b65952mr31719808637.10.1787004882615; Mon, 17 Aug 2026
 15:14:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260817052250.358796-1-rafad900@gmail.com> <f6efe2a8bf464a3cb4e53fdac161f6e7@realtek.com>
In-Reply-To: <f6efe2a8bf464a3cb4e53fdac161f6e7@realtek.com>
From: =?UTF-8?Q?Rafael_Alejandro_D=C3=ADaz_Cruz?= <rafad900@gmail.com>
Date: Mon, 17 Aug 2026 15:14:30 -0700
X-Gm-Features: AcwNN1VqEpAzCFhT2JiwIRdFirJ339vTwZ96Y7DaPSdfqkLHG_JZKSBx5wQ_wg8
Message-ID: <CALp66yFJCwBEwwP3wf25VEuvYBpuDSdeidyuvbpUtbvizP_3SQ@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: rtl8xxxu: Use local 'dev' variable for dev_warn()
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Ping-Ke,

Thanks for the suggestions so far. I'm trying to find the rtw-next
tree git.kernel.org but I can't seem to find it. Would you be able to
provide the link so that I can pull/fetch from it plz.
I found this link, but I'm not sure if its the right one :
https://github.com/pkshih/rtw/tree/rtw-next

Thanks,
Rafael.

On Mon, Aug 17, 2026 at 1:31=E2=80=AFAM Ping-Ke Shih <pkshih@realtek.com> w=
rote:
>
> rafad900 <rafad900@gmail.com> wrote:
> > To ensure consistent patterns, the device struct was
> > defined and used when dev_warn() is called.
> > This follows the logging pattern used in most of
> > rtl8xxxu files.
> >
> > Signed-off-by: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>
>
> NIPA reported many fail and warning items [1].
>
> The tree selection should be rtw-next. e.g. [PATCH rtw-next v3]
>
> [1] https://patchwork.kernel.org/project/linux-wireless/patch/20260817052=
250.358796-1-rafad900@gmail.com/
>
>
>
