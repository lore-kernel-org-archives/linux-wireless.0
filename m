Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55455 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab0JESOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 14:14:33 -0400
Message-ID: <4CAB6B08.4050801@candelatech.com>
Date: Tue, 05 Oct 2010 11:14:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com> <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com> <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com> <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com>
In-Reply-To: <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2010 10:55 AM, Luis R. Rodriguez wrote:
> On Tue, Oct 5, 2010 at 10:47 AM, Ben Greear<greearb@candelatech.com>  wrote:

>>> Please do, you can use the log2n approach, should take you 7 tries,
>>> each by a power of 2, start at the middle of course.
>>
>> Sure...will be a few minutes.
>>
>> If it's any sane bug, then hopefully I can hit it with a small
>> number.
>>
>> Out of curiosity, is there any particular number of STAs>  1 you guys
>> test with?
>
> We don't test this :)

Heh, I sort of supposed so :)

Anyway, I started with one, doubled each time,
and when I added the 4 to bring the system to
8 STA, it crapped itself.

I ran 64kbps UDP data streams on pairs of STA interfaces
for 5 minutes between STA increments.  I didn't get a chance to
start any traffic for the 4 that I had just added.

Earlier, I wasn't running any traffic at all, but of course
there is still noise on the network.

Note I'm running 'iwconfig foo' and 'cat /proc/net/wireless' in
the background as well, and that may have something to do with
things.


Oct  5 11:05:38 localhost kernel: =============================================================================
Oct  5 11:05:38 localhost kernel: BUG kmalloc-8192: Poison overwritten
Oct  5 11:05:38 localhost kernel: -----------------------------------------------------------------------------
Oct  5 11:05:38 localhost kernel:
Oct  5 11:05:38 localhost kernel: INFO: 0xf6362100-0xf63624d3. First byte 0x96 instead of 0x6b
Oct  5 11:05:38 localhost kernel: INFO: Allocated in ath_rxbuf_alloc+0x1d/0x74 [ath] age=11216 cpu=1 pid=0
Oct  5 11:05:38 localhost kernel: INFO: Freed in skb_release_data+0x8c/0x90 age=143 cpu=1 pid=8407
Oct  5 11:05:38 localhost kernel: INFO: Slab 0xc1fffc00 objects=3 used=2 fp=0xf6362030 flags=0x400040c1
Oct  5 11:05:38 localhost kernel: INFO: Object 0xf6362030 @offset=8240 fp=0x(null)
Oct  5 11:05:38 localhost kernel:
Oct  5 11:05:38 localhost kernel: Bytes b4 0xf6362020:  2a 00 00 00 67 fd 0b 00 5a 5a 5a 5a 5a 5a 5a 5a *...g�..ZZZZZZZZ
Oct  5 11:05:38 localhost kernel:  Object 0xf6362030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63620a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63620b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63620c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63620d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63620e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63620f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362100:  96 72 50 c0 11 2c 8e 7e 51 78 b2 6f 4c a2 58 ce .rP�.,.~Qx�oL�X
Oct  5 11:05:38 localhost kernel:  Object 0xf6362110:  b3 34 36 e4 a0 b3 d7 fb bb d9 c2 a7 04 9c 62 46 �46�.�����������٧..bF
Oct  5 11:05:38 localhost kernel:  Object 0xf6362120:  32 b9 8f 72 0b aa 38 13 22 9a fa 68 5d eb 11 55 2�.r.�8.".�h]�.U
Oct  5 11:05:38 localhost kernel:  Object 0xf6362130:  2f a3 95 08 16 bb 7e f4 45 45 77 2d c9 c1 63 0b /�...�~�EEw-��c.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362140:  c4 e6 cf 9b 3c cb 88 6e a0 fc 16 d7 2a eb de b3 ���.<�.n.�.�*�޳
Oct  5 11:05:38 localhost kernel:  Object 0xf6362150:  19 67 dd d6 ea c5 8e f1 e9 a1 23 0b 91 a4 49 24 .g����.�������#..�I$
Oct  5 11:05:38 localhost kernel:  Object 0xf6362160:  e0 b7 07 ce 68 fd b4 77 99 1b 6f 2d e4 3d 10 2f ��.�h�෴w..o-�=./
Oct  5 11:05:38 localhost kernel:  Object 0xf6362170:  a5 0e 46 8b 4f c3 75 2d 63 8e dd f5 25 9e da bb �.F.O�u-c.��%.�䥻
Oct  5 11:05:38 localhost kernel:  Object 0xf6362180:  64 db d3 f2 e2 3a ce bd 7d b5 2d de 75 c5 7a 48 d����:�۽}�-�u�zH
Oct  5 11:05:38 localhost kernel:  Object 0xf6362190:  17 f7 81 94 c4 48 5a 7a 6c ae a1 93 e5 74 98 67 .�..�HZzlޮ�.�t.g
Oct  5 11:05:38 localhost kernel:  Object 0xf63621a0:  1c a9 e3 80 35 65 24 c7 ce 7f 37 1b a7 a3 35 b5 .��.5e$��.7.婧�5�
Oct  5 11:05:38 localhost kernel:  Object 0xf63621b0:  ee a2 7e 9c 30 f2 a4 8d e1 f7 e6 8c 0c c7 79 71 ��~.0�.���..�yq
Oct  5 11:05:38 localhost kernel:  Object 0xf63621c0:  76 99 68 e5 e1 03 34 03 21 ff a9 35 98 20 0a ec v.h��.4.!��5...
Oct  5 11:05:38 localhost kernel:  Object 0xf63621d0:  0f fc 03 3d dc 88 75 b2 39 f2 65 68 fd 27 de 83 .�.=�.uᩲ9�eh�'�.
Oct  5 11:05:38 localhost kernel:  Object 0xf63621e0:  99 7a 61 a6 82 6d a9 af 79 c3 fa c3 20 fd 6d 2b .za�.m�򦩯y���.�m+
Oct  5 11:05:38 localhost kernel:  Object 0xf63621f0:  b9 fc 0d f7 be 4f b9 4f c3 a1 97 00 0a ad 0a e2 ù�.��O�Oá...�.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362200:  a6 88 03 42 5b c5 c7 cf 69 a5 42 5c b8 1b d7 6d ������..B[���iťB\�.�m
Oct  5 11:05:38 localhost kernel:  Object 0xf6362210:  92 7a 64 04 1e 39 77 26 7f 22 11 69 86 60 fe aa .zd..9w&.".i.`�ת
Oct  5 11:05:38 localhost kernel:  Object 0xf6362220:  1c d8 49 9a 9d a8 47 dd ae eb 33 53 cc ba 21 17 .�I..بG�ݮ�3S̺!.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362230:  62 78 92 99 ae f6 91 f8 71 da a4 35 6b 8c fd ce bx..뺮�.�qڤ5k.�
Oct  5 11:05:38 localhost kernel:  Object 0xf6362240:  95 28 a1 7f af 14 fc 7a b7 6e 52 81 bd 22 35 72 .(�.����.�z�nR.�"5r
Oct  5 11:05:38 localhost kernel:  Object 0xf6362250:  33 25 be 93 65 fd 1e 18 4c 4e 85 b5 55 e9 ed 53 3%�.e�..LN.�U��S
Oct  5 11:05:38 localhost kernel:  Object 0xf6362260:  52 a2 3f 5d 92 64 0e ec 45 ce 0c 3d 98 56 fe 1e R������?].d.�E�.=.V�.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362270:  9d 95 0d 49 b2 a7 cb c8 2a 7d 2b 8a 9a 59 36 51 ...I�첧��*}+..Y6Q
Oct  5 11:05:38 localhost kernel:  Object 0xf6362280:  ca 8c cf 4e c0 df 09 42 5f 61 40 a5 7f 92 d8 88 �.�N��.B_a@˥..�.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362290:  0d 51 75 4b c3 2e 48 e1 14 21 7f 00 23 be 42 55 .QuK�.H�.!..#ؾBU
Oct  5 11:05:38 localhost kernel:  Object 0xf63622a0:  9f 6b 88 67 d2 e1 ce 1c 6c 1f 39 b6 9b 73 e9 8c .k.g���.l.9Ҷ.s�.
Oct  5 11:05:38 localhost kernel:  Object 0xf63622b0:  3b 44 70 de 0d 4b 78 40 18 a3 3c fc 50 4c a6 89 ;Dp�.Kx@.�<�PL飦.
Oct  5 11:05:38 localhost kernel:  Object 0xf63622c0:  78 6e d1 c8 87 81 0c c0 41 2a d9 d1 98 10 48 b1 xn��...�A*��..Hѱ
Oct  5 11:05:38 localhost kernel:  Object 0xf63622d0:  e2 ef 37 77 98 e0 d3 61 67 9c 0c 5b 63 72 1c d3 ��7w.��ag..[cr.
Oct  5 11:05:38 localhost kernel:  Object 0xf63622e0:  ee 8b cf 29 7f 4b 18 b5 46 18 2e ba 43 e1 6a bb �.�).K.�F..⵺C�j�
Oct  5 11:05:38 localhost kernel:  Object 0xf63622f0:  4d 92 86 63 05 4b e9 f0 0d 9e 36 23 11 8a 38 8f M..c.K��..6#..8.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362300:  e4 4d 26 4b 64 51 53 05 c5 f9 01 8c 34 95 71 76 �M&KdQS.��..4.qv
Oct  5 11:05:38 localhost kernel:  Object 0xf6362310:  2d 57 a8 3e ef 8c 98 5c 36 d1 04 30 91 cf 51 5f -WỨ>�..\6�.0.�Q_
Oct  5 11:05:38 localhost kernel:  Object 0xf6362320:  b9 f4 ab b5 3a dc a7 e6 ae 98 23 21 80 50 c6 70 ��﹫�:�ܧ��.#!.P�p
Oct  5 11:05:38 localhost kernel:  Object 0xf6362330:  1c c7 14 65 af 48 54 53 76 6f bd 02 e4 b0 13 2a .�.e殯HTSvo�.��.*
Oct  5 11:05:38 localhost kernel:  Object 0xf6362340:  c6 37 eb 50 bc 20 35 d1 e0 6c 50 9c 1b d2 0e ed �7�P䰼.5��lP..�.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362350:  8f d1 b9 9f b6 7c 9c 5f ac f3 86 c1 b6 c0 31 86 .�ѹ.�|._��.���1.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362360:  a7 e6 c2 e4 78 f6 20 41 71 16 f8 7e bf 1d 47 6e ����x�.Aq.�~󶧿.Gn
Oct  5 11:05:38 localhost kernel:  Object 0xf6362370:  82 b9 df 67 d3 b2 fe f3 08 b0 e4 b4 53 b8 23 d8 .��g�߲��.���S󰴸#
Oct  5 11:05:38 localhost kernel:  Object 0xf6362380:  ad 46 3e 7b f4 6e 1d 00 de f7 c6 a9 9a 2f 4f 75 حF>{�n..��Ʃ./Ou
Oct  5 11:05:38 localhost kernel:  Object 0xf6362390:  a7 e3 99 8e b6 a5 f2 0d 73 ac 32 47 96 c1 cf 0b ��..������.s�2G.��.
Oct  5 11:05:38 localhost kernel:  Object 0xf63623a0:  79 80 7e cd ac 3d 42 41 32 af 62 79 3d f8 98 ce y.~ͬ=BA2򬬯by=�.
Oct  5 11:05:38 localhost kernel:  Object 0xf63623b0:  ab df d0 0c 24 36 8c 7c 66 78 18 c1 25 2a 06 95 ���.$6.|fx.�%*..
Oct  5 11:05:38 localhost kernel:  Object 0xf63623c0:  ce 9c ae 2c 84 71 3e 4c 70 4c d3 f2 f4 cc 5b b9 �.�,.q>LpL����[�
Oct  5 11:05:38 localhost kernel:  Object 0xf63623d0:  42 a0 a7 73 a1 73 1b b8 5c 7d 3c 76 b9 78 bd 6b B.�����s�s.�\}<v�x�k
Oct  5 11:05:38 localhost kernel:  Object 0xf63623e0:  30 ca b2 11 1d b3 30 6b 0e 5a f6 53 64 99 24 58 0�ʲ..�0k.Z�Sd.$X
Oct  5 11:05:38 localhost kernel:  Object 0xf63623f0:  a8 7a 47 e0 2e 1b cf b4 49 ea 3d 77 90 6f f2 87 �zG�..ϴI�=w.o�.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362400:  e2 36 0f 51 68 9d d3 70 84 bf 7e e6 c9 12 47 29 �6.Qh.�p.����~��.G)
Oct  5 11:05:38 localhost kernel:  Object 0xf6362410:  3b fb f2 32 34 58 fd 6d 2a a8 9d 47 bb b4 90 c2 ;��24X�m*�.G樻�.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362420:  8b a5 fc 42 d7 a7 e3 44 9c 36 37 0b b5 51 4b cc .¥�Bק�D.67.�QK
Oct  5 11:05:38 localhost kernel:  Object 0xf6362430:  2a eb 55 e2 fe 98 cb 4f 34 29 b8 18 59 f9 af c1 *�U��.�O4)�.Y��
Oct  5 11:05:38 localhost kernel:  Object 0xf6362440:  e7 a0 3a e8 1e 01 37 80 4d 6d 9c 37 e6 8f ae 82 �.:�..7.Mm.7�.������.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362450:  59 5d e4 99 3f 6e f3 cf d6 26 c5 21 1b aa ce fd Y]�.?n���&�!.��
Oct  5 11:05:38 localhost kernel:  Object 0xf6362460:  01 d3 59 20 38 99 5c 85 95 de d8 01 14 1a 8f 65 .�Y.8.\..��....e
Oct  5 11:05:38 localhost kernel:  Object 0xf6362470:  dc 54 2a f6 cd 3b 9a 54 73 0d 34 1f 73 19 ac 5c �T*��;.Ts.4.s.䪬\
Oct  5 11:05:38 localhost kernel:  Object 0xf6362480:  af 38 9c 4d 2a a3 7b ec b3 1a 21 c3 fe 42 4e 8f �8.M*�{��.!��BN.
Oct  5 11:05:38 localhost kernel:  Object 0xf6362490:  03 a1 14 38 f2 bf a3 da 60 69 08 42 85 9e 8c 01 .쳡.8����`i.B....
Oct  5 11:05:38 localhost kernel:  Object 0xf63624a0:  18 e4 b7 6e a3 f6 b9 11 bb ee 0d 07 0d 2a f2 7c .�򿣷n���.��...*�|
Oct  5 11:05:38 localhost kernel:  Object 0xf63624b0:  9c 13 2c 56 56 d5 05 8d 2a e3 45 83 26 09 50 3d ..,VV�..*�E.&.P=
Oct  5 11:05:38 localhost kernel:  Object 0xf63624c0:  42 7c 49 5a bd ac 2d ca 49 90 27 2c e7 42 ef e1 B|IZ�����-�I.',�B�
Oct  5 11:05:38 localhost kernel:  Object 0xf63624d0:  42 2f fa 99 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b B/�.kkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63624e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63624f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63625a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63625b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63625c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63625d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63625e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63625f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63626a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63626b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63626c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63626d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63626e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63626f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63627a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63627b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63627c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63627d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63627e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63627f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63628a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63628b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63628c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63628d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63628e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63628f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362900:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362910:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362920:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362950:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362980:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362990:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63629a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63629b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63629c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63629d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63629e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf63629f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362a00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362a10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362a20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362a30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362a40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362a50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362a60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362a70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362a80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362a90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362aa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ad0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362af0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362b00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362b10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362b20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362b30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362b40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362b50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362b60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362b70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362b80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362b90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362bb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362bc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362bd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362be0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362bf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362c00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362c10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362c20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362c30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362c40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362c50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362c60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362c70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362c80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362c90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362cb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362cc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362cd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ce0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362cf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362d00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362d10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362d20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362d30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362d40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362d50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362d60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362d70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362d80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362d90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362da0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362db0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362dc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362dd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362de0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362df0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362e00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362e10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362e20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362e30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362e40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362e50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362e60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362e70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362e80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362e90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362eb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ed0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362f00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362f10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362f20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362f30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362f40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362f50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362f60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362f70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362f80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362f90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362fa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362fb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362fc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362fd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362fe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6362ff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6363000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6363010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel:  Object 0xf6363020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:38 localhost kernel: Redzone 0xf6364030:  bb bb bb bb                                     ʻ���
Oct  5 11:05:38 localhost kernel: Padding 0xf6364058:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
Oct  5 11:05:38 localhost kernel: Pid: 8416, comm: parse-iwconfig. Not tainted 2.6.36-rc6-wl+ #5
Oct  5 11:05:38 localhost kernel: Call Trace:
Oct  5 11:05:38 localhost kernel: [<c04ab513>] print_trailer+0xdc/0xe4
Oct  5 11:05:38 localhost kernel: [<c04ab8e9>] check_bytes_and_report+0x96/0xcc
Oct  5 11:05:38 localhost kernel: [<c04ab9c6>] check_object+0xa7/0x15d
Oct  5 11:05:38 localhost kernel: [<c04acc37>] __slab_alloc+0x339/0x3dd
Oct  5 11:05:38 localhost kernel: [<c0455df5>] ? mark_held_locks+0x47/0x5f
Oct  5 11:05:38 localhost kernel: [<c04ad0d2>] ? kmem_cache_alloc+0xa0/0xc5
Oct  5 11:05:38 localhost kernel: [<c04ad6fd>] __kmalloc_track_caller+0xa1/0xf2
Oct  5 11:05:38 localhost kernel: [<c06c7331>] ? skb_copy+0x2e/0x83
Oct  5 11:05:38 localhost kernel: [<c06c7331>] ? skb_copy+0x2e/0x83
Oct  5 11:05:38 localhost kernel: [<c06c6d6a>] __alloc_skb+0x58/0xf4
Oct  5 11:05:38 localhost kernel: [<c06c7331>] skb_copy+0x2e/0x83
Oct  5 11:05:38 localhost kernel: [<f8d426dd>] ieee80211_prepare_and_rx_handle+0x3b1/0x86d [mac80211]
Oct  5 11:05:38 localhost kernel: [<c0455bee>] ? mark_lock+0x1e/0x1de
Oct  5 11:05:38 localhost kernel: [<c0455bee>] ? mark_lock+0x1e/0x1de
Oct  5 11:05:38 localhost kernel: [<f8d31ab4>] ? sta_info_get_bss+0xb0/0x10c [mac80211]
Oct  5 11:05:38 localhost kernel: [<f8d43352>] ieee80211_rx+0x70f/0x7b5 [mac80211]
Oct  5 11:05:38 localhost kernel: [<c04ad729>] ? __kmalloc_track_caller+0xcd/0xf2
Oct  5 11:05:38 localhost kernel: [<c0456038>] ? trace_hardirqs_on_caller+0xeb/0x125
Oct  5 11:05:38 localhost kernel: [<f86e3836>] ath_rx_send_to_mac80211+0x5a/0x60 [ath9k]
Oct  5 11:05:38 localhost kernel: [<c045607d>] ? trace_hardirqs_on+0xb/0xd
Oct  5 11:05:38 localhost kernel: [<f86e5066>] ath_rx_tasklet+0x1253/0x130e [ath9k]
Oct  5 11:05:38 localhost kernel: [<f86e3232>] ath9k_tasklet+0x9a/0x12a [ath9k]
Oct  5 11:05:38 localhost kernel: [<c0438fd1>] tasklet_action+0x73/0xc6
Oct  5 11:05:38 localhost kernel: [<c043945f>] __do_softirq+0x86/0x111
Oct  5 11:05:38 localhost kernel: [<c0439520>] do_softirq+0x36/0x5a
Oct  5 11:05:38 localhost kernel: [<c0439659>] irq_exit+0x35/0x69
Oct  5 11:05:38 localhost kernel: [<c0403fb9>] do_IRQ+0x86/0x9a
Oct  5 11:05:38 localhost kernel: [<c04034ee>] common_interrupt+0x2e/0x40
Oct  5 11:05:38 localhost kernel: FIX kmalloc-8192: Restoring 0xf6362100-0xf63624d3=0x6b
Oct  5 11:05:38 localhost kernel:
Oct  5 11:05:38 localhost kernel: FIX kmalloc-8192: Marking all objects used
Oct  5 11:05:39 localhost kernel: sta5: deauthenticating from 00:14:d1:c6:d2:54 by local choice (reason=3)
Oct  5 11:05:39 localhost kernel: ieee80211 phy0: Removed STA 00:14:d1:c6:d2:54
Oct  5 11:05:39 localhost kernel: ieee80211 phy0: Destroyed STA 00:14:d1:c6:d2:54
Oct  5 11:05:41 localhost kernel: sta6: no IPv6 routers present
Oct  5 11:05:41 localhost kernel: =============================================================================
Oct  5 11:05:41 localhost kernel: BUG kmalloc-8192: Poison overwritten
Oct  5 11:05:41 localhost kernel: -----------------------------------------------------------------------------
Oct  5 11:05:41 localhost kernel:
Oct  5 11:05:41 localhost kernel: INFO: 0xf34d40a0-0xf34d411f. First byte 0x80 instead of 0x6b
Oct  5 11:05:41 localhost kernel: INFO: Allocated in ath_rxbuf_alloc+0x1d/0x74 [ath] age=9852 cpu=1 pid=0
Oct  5 11:05:41 localhost kernel: INFO: Freed in skb_release_data+0x8c/0x90 age=66 cpu=1 pid=0
Oct  5 11:05:41 localhost kernel: INFO: Slab 0xc1fa2a00 objects=3 used=2 fp=0xf34d4060 flags=0x400040c1
Oct  5 11:05:41 localhost kernel: INFO: Object 0xf34d4060 @offset=16480 fp=0x(null)
Oct  5 11:05:41 localhost kernel:
Oct  5 11:05:41 localhost kernel: Bytes b4 0xf34d4050:  00 00 00 00 fe 02 0c 00 5a 5a 5a 5a 5a 5a 5a 5a ....�...ZZZZZZZZ
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d40a0:  80 00 00 00 ff ff ff ff ff ff 00 1d 7e 23 46 52 ....������..~#FR
Oct  5 11:05:41 localhost kernel:  Object 0xf34d40b0:  00 1d 7e 23 46 52 00 ad 87 a1 f9 6a 90 06 00 00 ..~#FR.�.��j....
Oct  5 11:05:41 localhost kernel:  Object 0xf34d40c0:  64 00 11 04 00 0f 46 65 72 6e 64 61 6c 65 43 68 d.....FerndaleCh
Oct  5 11:05:41 localhost kernel:  Object 0xf34d40d0:  61 6d 62 65 72 01 08 82 84 8b 96 24 30 48 6c 03 amber......$0Hl.
Oct  5 11:05:41 localhost kernel:  Object 0xf34d40e0:  01 06 05 04 00 01 00 00 2a 01 04 2f 01 04 32 04 ........*../..2.
Oct  5 11:05:41 localhost kernel:  Object 0xf34d40f0:  0c 12 18 60 dd 09 00 10 18 02 01 f4 00 00 00 dd ...`�......�...
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4100:  18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 ..P�....P�....P
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4110:  02 01 00 00 50 f2 02 00 00 51 f0 2b 8f 51 f0 8f ....P�...Q�+.Q�.
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d41a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d41b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d41c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d41d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d41e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d41f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d42a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d42b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d42c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d42d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d42e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d42f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d43a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d43b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d43c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d43d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d43e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d43f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d44a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d44b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d44c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d44d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d44e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d44f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d45a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d45b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d45c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d45d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d45e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d45f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d46a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d46b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d46c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d46d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d46e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d46f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d47a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d47b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d47c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d47d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d47e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d47f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d48a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d48b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d48c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d48d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d48e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d48f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4900:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4910:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4920:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4950:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4980:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4990:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d49a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d49b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d49c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d49d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d49e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d49f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4a00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4a10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4a20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4a30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4a40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4a50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4a60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4a70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4a80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4a90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4aa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ad0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4af0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4b00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4b10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4b20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4b30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4b40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4b50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4b60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4b70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4b80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4b90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4bb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4bc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4bd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4be0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4bf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4c00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4c10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4c20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4c30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4c40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4c50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4c60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4c70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4c80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4c90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4cb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4cc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4cd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ce0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4cf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4d00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4d10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4d20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4d30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4d40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4d50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4d60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4d70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4d80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4d90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4da0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4db0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4dc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4dd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4de0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4df0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4e00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4e10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4e20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4e30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4e40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4e50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4e60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4e70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4e80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4e90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4eb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ed0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4f00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4f10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4f20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4f30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4f40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4f50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4f60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4f70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4f80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4f90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4fa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4fb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4fc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4fd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4fe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d4ff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d5000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d5010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d5020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d5030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d5040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel:  Object 0xf34d5050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 11:05:41 localhost kernel: Redzone 0xf34d6060:  bb bb bb bb                                     ��������
Oct  5 11:05:41 localhost kernel: Padding 0xf34d6088:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
Oct  5 11:05:41 localhost kernel: Pid: 0, comm: kworker/0:0 Not tainted 2.6.36-rc6-wl+ #5
Oct  5 11:05:41 localhost kernel: Call Trace:
Oct  5 11:05:41 localhost kernel: [<c04ab513>] print_trailer+0xdc/0xe4
Oct  5 11:05:41 localhost kernel: [<c04ab8e9>] check_bytes_and_report+0x96/0xcc
Oct  5 11:05:41 localhost kernel: [<c04ab9c6>] check_object+0xa7/0x15d
Oct  5 11:05:41 localhost kernel: [<c04acc37>] __slab_alloc+0x339/0x3dd
Oct  5 11:05:41 localhost kernel: [<c0455df5>] ? mark_held_locks+0x47/0x5f
Oct  5 11:05:41 localhost kernel: [<c04ad0d2>] ? kmem_cache_alloc+0xa0/0xc5
Oct  5 11:05:41 localhost kernel: [<c04ad6fd>] __kmalloc_track_caller+0xa1/0xf2
Oct  5 11:05:41 localhost kernel: [<c06c7331>] ? skb_copy+0x2e/0x83
Oct  5 11:05:41 localhost kernel: [<c06c7331>] ? skb_copy+0x2e/0x83
Oct  5 11:05:41 localhost kernel: [<c06c6d6a>] __alloc_skb+0x58/0xf4
Oct  5 11:05:41 localhost kernel: [<c06c7331>] skb_copy+0x2e/0x83
Oct  5 11:05:41 localhost kernel: [<f8d426dd>] ieee80211_prepare_and_rx_handle+0x3b1/0x86d [mac80211]
Oct  5 11:05:41 localhost kernel: [<c0455bee>] ? mark_lock+0x1e/0x1de
Oct  5 11:05:41 localhost kernel: [<f8d31ab4>] ? sta_info_get_bss+0xb0/0x10c [mac80211]
Oct  5 11:05:41 localhost kernel: [<f8d43352>] ieee80211_rx+0x70f/0x7b5 [mac80211]
Oct  5 11:05:41 localhost kernel: [<c04ad729>] ? __kmalloc_track_caller+0xcd/0xf2
Oct  5 11:05:41 localhost kernel: [<c0456038>] ? trace_hardirqs_on_caller+0xeb/0x125
Oct  5 11:05:41 localhost kernel: [<f86e3836>] ath_rx_send_to_mac80211+0x5a/0x60 [ath9k]
Oct  5 11:05:41 localhost kernel: [<c045607d>] ? trace_hardirqs_on+0xb/0xd
Oct  5 11:05:41 localhost kernel: [<f86e5066>] ath_rx_tasklet+0x1253/0x130e [ath9k]
Oct  5 11:05:41 localhost kernel: [<f86e3232>] ath9k_tasklet+0x9a/0x12a [ath9k]
Oct  5 11:05:41 localhost kernel: [<c0438fd1>] tasklet_action+0x73/0xc6
Oct  5 11:05:41 localhost kernel: [<c043945f>] __do_softirq+0x86/0x111
Oct  5 11:05:41 localhost kernel: [<c0439520>] do_softirq+0x36/0x5a
Oct  5 11:05:41 localhost kernel: [<c0439659>] irq_exit+0x35/0x69
Oct  5 11:05:41 localhost kernel: [<c0403fb9>] do_IRQ+0x86/0x9a
Oct  5 11:05:41 localhost kernel: [<c04034ee>] common_interrupt+0x2e/0x40
Oct  5 11:05:41 localhost kernel: [<c045007b>] ? do_adjtimex+0x217/0x55e
Oct  5 11:05:41 localhost kernel: [<c0408245>] ? mwait_idle+0x5c/0x6c
Oct  5 11:05:41 localhost kernel: [<c040227f>] cpu_idle+0x4e/0x6b
Oct  5 11:05:41 localhost kernel: [<c075b591>] start_secondary+0x1a8/0x1ad
Oct  5 11:05:41 localhost kernel: FIX kmalloc-8192: Restoring 0xf34d40a0-0xf34d411f=0x6b

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

