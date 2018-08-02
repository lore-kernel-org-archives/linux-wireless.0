Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.e-nautia.com ([37.187.142.32]:36289 "EHLO ns.e-nautia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729982AbeHBTN3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 15:13:29 -0400
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
From: Berto Gerard <gerard.berto@e-nautia.com>
Subject: bug: many pcieport errors
Message-ID: <16fa1240-cc8d-1c6c-7bf2-ea8d176cec5b@e-nautia.com> (sfid-20180802_192134_779261_77CB3946)
Date: Thu, 2 Aug 2018 19:16:16 +0200
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------2EE078C6B1299E5CF2263ADD"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------2EE078C6B1299E5CF2263ADD
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I help on the Ubuntu French forum and we see many times the same 
problem: kern.log and syslog are filled with an error which is repeated. 
Here is the error:

|[ 22.275320] pcieport 0000:00:1c.4: device [8086:9d14] error 
status/mask=00000001/00000000 [ 22.275322] pcieport 0000:00:1c.4: [ 0] 
Receiver Error (First) [ 22.277322] pcieport 0000:00:1c.4: PCIe Bus 
Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID) [ 
22.277325] pcieport 0000:00:1c.4: device [8086:9d14] error 
status/mask=00000001/00000000 [ 22.277327] pcieport 0000:00:1c.4: [ 0] 
Receiver Error (First) [ 22.278793] pcieport 0000:00:1c.4: PCIe Bus 
Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID) [ 
22.278795] pcieport 0000:00:1c.4: device [8086:9d14] error 
status/mask=00000001/00000000 [ 22.278796] pcieport 0000:00:1c.4: [ 0] 
Receiver Error (First) [ 22.279211] pcieport 0000:00:1c.4: PCIe Bus 
Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID) [ 
22.279214] pcieport 0000:00:1c.4: device [8086:9d14] error 
status/mask=00000001/00000000 [ 22.279216] pcieport 0000:00:1c.4: [ 0] 
Receiver Error (First) [ 22.279605] pcieport 0000:00:1c.4: PCIe Bus 
Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID) [ 
22.279608] pcieport 0000:00:1c.4: device [8086:9d14] error 
status/mask=00000001/00000000 [ 22.279610] pcieport 0000:00:1c.4: [ 0] 
Receiver Error (First) [ 22.399607] pcieport 0000:00:1c.4: PCIe Bus 
Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID) [ 
22.399611] pcieport 0000:00:1c.4: device [8086:9d14] error 
status/mask=00000001/00000000 [ 22.399613] pcieport 0000:00:1c.4: [ 0] 
Receiver Error (First) [ 22.538521] pcieport 0000:00:1c.4: PCIe Bus 
Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID) [ 
22.538525] pcieport 0000:00:1c.4: device [8086:9d14] error 
status/mask=00000001/00000000 [ 22.538527] pcieport 0000:00:1c.4: [ 0] 
Receiver Error (First) |||||

||This problem leads to filled hard drive (and it's fast!) for Ubuntu 
16.04 versions, and for the 18.04.1 version, the live session can't be 
used: screen remains black with these errors written in white.

These two boot parameters avoid the problem but they have drawbacks, so 
it's a just a bypass solution: "pci=noaer" or "pci_aspm=off"

We also see that

|[8086:9d14]|

in the error is an intel bridge (Skylake architecture), and

|0000:00:1c.4|

is the RTL8723BE wifi card.
Many of the Ubuntu's French forum threads have the RTL8723BE card, and 
every thread has this intel bridge. So I don't know if it's specific of 
the RTL8723BE card, but on my pc, I don't have the problem and I have 
the RTL8723BE card but not the same intel bridge (Haswell architecture) 
and I tried with Xubuntu 16.04.1, Ubuntu 16.04.3 and Xubuntu 18.04.1 and 
no errors logged.

When we do
sudo modprobe -r rtl8723be
the errors stop logged. So maybe the boot parameter 
"modprobe.blacklist=rtl8723be" could be useful for tests.

That's all we know. If you have questions or some tests for finding 
where the problem is, don't hesitate.
Best regards

--------------2EE078C6B1299E5CF2263ADD
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <p>Hello, </p>
    <p>I help on the Ubuntu French forum and we see many times the same
      problem: kern.log and syslog are filled with an error which is
      repeated. Here is the error:</p>
    <pre><code>[   22.275320] pcieport 0000:00:1c.4:   device [8086:9d14] error status/mask=00000001/00000000
[   22.275322] pcieport 0000:00:1c.4:    [ 0] Receiver Error         (First)
[   22.277322] pcieport 0000:00:1c.4: PCIe Bus Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID)
[   22.277325] pcieport 0000:00:1c.4:   device [8086:9d14] error status/mask=00000001/00000000
[   22.277327] pcieport 0000:00:1c.4:    [ 0] Receiver Error         (First)
[   22.278793] pcieport 0000:00:1c.4: PCIe Bus Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID)
[   22.278795] pcieport 0000:00:1c.4:   device [8086:9d14] error status/mask=00000001/00000000
[   22.278796] pcieport 0000:00:1c.4:    [ 0] Receiver Error         (First)
[   22.279211] pcieport 0000:00:1c.4: PCIe Bus Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID)
[   22.279214] pcieport 0000:00:1c.4:   device [8086:9d14] error status/mask=00000001/00000000
[   22.279216] pcieport 0000:00:1c.4:    [ 0] Receiver Error         (First)
[   22.279605] pcieport 0000:00:1c.4: PCIe Bus Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID)
[   22.279608] pcieport 0000:00:1c.4:   device [8086:9d14] error status/mask=00000001/00000000
[   22.279610] pcieport 0000:00:1c.4:    [ 0] Receiver Error         (First)
[   22.399607] pcieport 0000:00:1c.4: PCIe Bus Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID)
[   22.399611] pcieport 0000:00:1c.4:   device [8086:9d14] error status/mask=00000001/00000000
[   22.399613] pcieport 0000:00:1c.4:    [ 0] Receiver Error         (First)
[   22.538521] pcieport 0000:00:1c.4: PCIe Bus Error: severity=Corrected, type=Physical Layer, id=00e4(Receiver ID)
[   22.538525] pcieport 0000:00:1c.4:   device [8086:9d14] error status/mask=00000001/00000000
[   22.538527] pcieport 0000:00:1c.4:    [ 0] Receiver Error         (First)


</code><code>
</code><code></code></pre>
    <p><code></code>This problem leads to filled hard drive (and it's
      fast!) for Ubuntu 16.04 versions, and for the 18.04.1 version, the
      live session can't be used: screen remains black with these errors
      written in white.</p>
    <p>These two boot parameters avoid the problem but they have
      drawbacks, so it's a just a bypass solution: "pci=noaer" or
      "pci_aspm=off"</p>
    <p>We also see that <br>
    </p>
    <pre><code>[8086:9d14]</code></pre>
    in the error is an intel bridge (Skylake architecture), and <br>
    <pre><code>0000:00:1c.4</code></pre>
    is the RTL8723BE wifi card. <br>
    Many of the Ubuntu's French forum threads have the RTL8723BE card,
    and every thread has this intel bridge. So I don't know if it's
    specific of the RTL8723BE card, but on my pc, I don't have the
    problem and I have the RTL8723BE card but not the same intel bridge
    (Haswell architecture) and I tried with Xubuntu 16.04.1, Ubuntu
    16.04.3 and Xubuntu 18.04.1 and no errors logged.<br>
    <br>
    When we do<br>
    sudo modprobe -r rtl8723be<br>
    the errors stop logged. So maybe the boot parameter
    "modprobe.blacklist=rtl8723be" could be useful for tests.<br>
    <br>
    That's all we know. If you have questions or some tests for finding
    where the problem is, don't hesitate.<br>
    Best regards<br>
  </body>
</html>

--------------2EE078C6B1299E5CF2263ADD--
