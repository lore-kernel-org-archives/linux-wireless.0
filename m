Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA56DC4332F
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Mar 2022 20:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiCDUEZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Mar 2022 15:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiCDUEQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Mar 2022 15:04:16 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4CA23932D
        for <linux-wireless@vger.kernel.org>; Fri,  4 Mar 2022 11:59:19 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id a6so8914046oid.9
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2022 11:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=TZsLPFPAJysjpvYKnhk2yuVlT5VtkY28RzPQUmCVMes=;
        b=d79KYO7bclqyd893mehkvfrDXXTBetRVp9y+SK5olh4qnLW+6SiaixoSlQKfari/Dg
         3ne3FPm0eVAEQzbaDjUKZQZEB7dVHbZeYOFa/cSKe/pEsU3rzfCGGsb0bDNL/lAGdOFQ
         KYgm0IOAYe8gJYtiTNLkGk3m09dPjzSAJbUJHVeSg9Jptrfwi+eTEFB8jG/8atIzyvED
         SWQLz6X5zSDs+wf19Ln20kae/zpnifklUFD/ihu9GRYuh6RHotXUIfTBHHUS/CQjlZDa
         1yo63S5KECMYU55pNmniIEWxoNbpXvmTE/hTYzhKYKxVJTMbT/uhGw32C3IQqUQ9gHvA
         aHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TZsLPFPAJysjpvYKnhk2yuVlT5VtkY28RzPQUmCVMes=;
        b=YQ6f784Bn4ncQWyFfmClAE/0tjCAcx9Iel09BnlgbfbRqxmz0XvTyu6Kd74fh6MD0H
         jT0eDxPaUaUXf7nZKt/Bjli8LHD4eiiBCTgKcpmJeF0ou4Q42frWOpnQr1/Oj/3ysQ9e
         sTC4NKS0iunMWlCSNt/d410bqH6NrZ2RfwS9sLMLJmLYlIA6Q8ORivpb9DlB+jlJj0Fy
         pAgdrK+WMRWxazeaKeE8WLb93pIjvZsp9wHcfn6qgFoTH2s4MtlEACI0yRIwRcQIQZ3a
         4H7yPPS4Tlw8QWxWOZtkVYZX0L0iKDyIxi+mVSv/E7E6pXJpiDhVHgn/ENaZDe6zUf7S
         4fFw==
X-Gm-Message-State: AOAM531KlgsyDxQBAeqA3aLD/TdhPV/RMq7qCVci9A7HV98UlCvr23im
        pOM6Cb2yY/mHF8aOI/h6gWx8/A4+Jq08F0/uuLZcvXJC
X-Google-Smtp-Source: ABdhPJwO/Qf5baxH+fgizkwR8gkKtkMBN1jn5wRglTbbkQacMcCCnCuKo5qN+ncJyklqMcc/PoEuqwS1vwZvXtlw8HI=
X-Received: by 2002:a05:6808:bce:b0:2d9:a01a:487d with SMTP id
 o14-20020a0568080bce00b002d9a01a487dmr534307oik.200.1646423954805; Fri, 04
 Mar 2022 11:59:14 -0800 (PST)
MIME-Version: 1.0
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 4 Mar 2022 14:59:03 -0500
Message-ID: <CADnq5_MM8w=U6WqRDbwHrjP4Jpco0bUKEsE5QiTYiYAEK1xtBg@mail.gmail.com>
Subject: Way to enumerate wireless adapters in kernel
To:     Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi, is there a way to enumerate wireless adapters in the kernel and
determine what their channel and frequency is?  I'm looking for a way
to determine this from another component in the kernel so as to avoid
any potential frequency interface from another device in the kernel.

Thanks,

Alex
